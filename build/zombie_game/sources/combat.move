module game::combat {
    use sui::object::UID;
    use sui::transfer;
    use sui::tx_context::TxContext;
    use sui::event;
    use game::player::{Self, Player};
    use game::zombie::{Self, Zombie};

    // Résultat d'un combat
    public struct CombatResult has key {
        id: UID,
        player_won: bool,
        damage_dealt: u64,
        damage_taken: u64,
        xp_gained: u64,
        coins_gained: u64,
    }

    // Événements
    public struct CombatFinished has copy, drop {
        player_won: bool,
        xp_gained: u64,
        coins_gained: u64,
        damage_taken: u64,
    }

    // Calculer les dégâts (Attaque - Défense, minimum 1)
    fun calculate_damage(attack: u64, defense: u64): u64 {
        if (attack > defense) {
            attack - defense
        } else {
            1 // Dégâts minimum
        }
    }

    // Combat principal
    public fun fight(
        player: &mut Player,
        zombie: Zombie,
        ctx: &mut TxContext
    ) {
        // Vérifier que le joueur est vivant
        assert!(player::is_alive(player), 1);

        let player_damage = calculate_damage(
            player::get_attack(player),
            zombie::get_defense(&zombie)
        );
        
        let zombie_damage = calculate_damage(
            zombie::get_attack(&zombie),
            player::get_defense(player)
        );

        let zombie_health = zombie::get_health(&zombie);
        let player_health = player::get_health(player);

        // Calculer combien de tours pour tuer chacun
        let zombie_turns_to_die = (zombie_health + player_damage - 1) / player_damage;
        let player_turns_to_die = (player_health + zombie_damage - 1) / zombie_damage;

        let player_won: bool;
        let xp_gained: u64;
        let coins_gained: u64;
        let total_damage_taken: u64;

        if (zombie_turns_to_die <= player_turns_to_die) {
            // Le joueur gagne
            player_won = true;
            
            // Le joueur prend des dégâts (nombre de tours - 1)
            if (zombie_turns_to_die > 0) {
                total_damage_taken = zombie_damage * (zombie_turns_to_die - 1);
            } else {
                total_damage_taken = 0;
            };
            
            xp_gained = zombie::get_xp_reward(&zombie);
            coins_gained = zombie::get_coin_reward(&zombie);
            
            player::gain_experience(player, xp_gained);
            player::add_coins(player, coins_gained);
            player::take_damage(player, total_damage_taken);
        } else {
            // Le joueur perd
            player_won = false;
            total_damage_taken = player_health;
            xp_gained = 0;
            coins_gained = 0;
            
            player::take_damage(player, total_damage_taken);
        };

        // Créer le résultat du combat
        let result = CombatResult {
            id: object::new(ctx),
            player_won,
            damage_dealt: zombie_health,
            damage_taken: total_damage_taken,
            xp_gained,
            coins_gained,
        };

        // Émettre l'événement
        event::emit(CombatFinished {
            player_won,
            xp_gained,
            coins_gained,
            damage_taken: total_damage_taken,
        });

        // Détruire le zombie
        zombie::destroy_zombie(zombie);

        // Transférer le résultat au joueur
        transfer::transfer(result, tx_context::sender(ctx));
    }

    // Getter pour le résultat
    public fun get_result(result: &CombatResult): (bool, u64, u64, u64, u64) {
        (
            result.player_won,
            result.damage_dealt,
            result.damage_taken,
            result.xp_gained,
            result.coins_gained
        )
    }
}