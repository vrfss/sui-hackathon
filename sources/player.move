module game::player {
    use sui::object::UID;
    use sui::transfer;
    use sui::tx_context::TxContext;
    use sui::event;
    use std::string::{Self, String};

    // Structure du joueur
    public struct Player has key, store {
        id: UID,
        name: String,
        health: u64,
        max_health: u64,
        attack: u64,
        defense: u64,
        level: u64,
        experience: u64,
        coins: u64,
    }

    // Événements
    public struct PlayerCreated has copy, drop {
        player_id: address,
        name: String,
    }

    public struct PlayerLeveledUp has copy, drop {
        player_id: address,
        new_level: u64,
    }

    public struct PlayerDied has copy, drop {
        player_id: address,
    }

    // Créer un nouveau joueur
    public fun create_player(
        name: vector<u8>,
        ctx: &mut TxContext
    ) {
        let player = Player {
            id: object::new(ctx),
            name: string::utf8(name),
            health: 100,
            max_health: 100,
            attack: 10,
            defense: 5,
            level: 1,
            experience: 0,
            coins: 100,
        };

        let sender = tx_context::sender(ctx);
        
        event::emit(PlayerCreated {
            player_id: sender,
            name: player.name,
        });

        transfer::transfer(player, sender);
    }

    // Gagner de l'expérience et monter de niveau
    public fun gain_experience(player: &mut Player, xp: u64) {
        player.experience = player.experience + xp;
        
        // Calculer XP nécessaire pour level up
        let xp_needed = player.level * 100;
        
        if (player.experience >= xp_needed) {
            level_up(player);
        }
    }

    // Monter de niveau
    fun level_up(player: &mut Player) {
        player.level = player.level + 1;
        player.experience = 0; // Reset XP
        player.max_health = player.max_health + 20;
        player.health = player.max_health; // Full heal on level up
        player.attack = player.attack + 3;
        player.defense = player.defense + 2;

        event::emit(PlayerLeveledUp {
            player_id: object::uid_to_address(&player.id),
            new_level: player.level,
        });
    }

    // Prendre des dégâts
    public fun take_damage(player: &mut Player, damage: u64) {
        if (damage >= player.health) {
            player.health = 0;
            event::emit(PlayerDied {
                player_id: object::uid_to_address(&player.id),
            });
        } else {
            player.health = player.health - damage;
        }
    }

    // Se soigner
    public fun heal(player: &mut Player, amount: u64) {
        let cost = 10;
        assert!(player.coins >= cost, 0); // Erreur si pas assez de coins
        
        player.coins = player.coins - cost;
        
        let new_health = player.health + amount;
        if (new_health > player.max_health) {
            player.health = player.max_health;
        } else {
            player.health = new_health;
        }
    }

    // Ajouter des pièces
    public fun add_coins(player: &mut Player, amount: u64) {
        player.coins = player.coins + amount;
    }

    // Getters
    public fun get_health(player: &Player): u64 {
        player.health
    }

    public fun get_max_health(player: &Player): u64 {
        player.max_health
    }

    public fun get_attack(player: &Player): u64 {
        player.attack
    }

    public fun get_defense(player: &Player): u64 {
        player.defense
    }

    public fun get_level(player: &Player): u64 {
        player.level
    }

    public fun get_experience(player: &Player): u64 {
        player.experience
    }

    public fun get_coins(player: &Player): u64 {
        player.coins
    }

    public fun get_name(player: &Player): String {
        player.name
    }

    public fun is_alive(player: &Player): bool {
        player.health > 0
    }
}