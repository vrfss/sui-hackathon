module game::zombie {
    use sui::object::UID;
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::event;

    // Types de zombies
    const ZOMBIE_NORMAL: u8 = 1;
    const ZOMBIE_STRONG: u8 = 2;
    const ZOMBIE_BOSS: u8 = 3;

    // Structure du zombie
    public struct Zombie has key, store {
        id: UID,
        zombie_type: u8,
        health: u64,
        max_health: u64,
        attack: u64,
        defense: u64,
        xp_reward: u64,
        coin_reward: u64,
    }

    // Événements
    public struct ZombieSpawned has copy, drop {
        zombie_type: u8,
        health: u64,
    }

    public struct ZombieDestroyed has copy, drop {
        zombie_type: u8,
    }

    // Spawn un zombie normal
    public fun spawn_normal(ctx: &mut TxContext) {
        let zombie = Zombie {
            id: object::new(ctx),
            zombie_type: ZOMBIE_NORMAL,
            health: 50,
            max_health: 50,
            attack: 8,
            defense: 2,
            xp_reward: 25,
            coin_reward: 10,
        };

        event::emit(ZombieSpawned {
            zombie_type: ZOMBIE_NORMAL,
            health: 50,
        });

        transfer::transfer(zombie, tx_context::sender(ctx));
    }

    // Spawn un zombie fort
    public fun spawn_strong(ctx: &mut TxContext) {
        let zombie = Zombie {
            id: object::new(ctx),
            zombie_type: ZOMBIE_STRONG,
            health: 100,
            max_health: 100,
            attack: 15,
            defense: 5,
            xp_reward: 50,
            coin_reward: 25,
        };

        event::emit(ZombieSpawned {
            zombie_type: ZOMBIE_STRONG,
            health: 100,
        });

        transfer::transfer(zombie, tx_context::sender(ctx));
    }

    // Spawn un zombie boss
    public fun spawn_boss(ctx: &mut TxContext) {
        let zombie = Zombie {
            id: object::new(ctx),
            zombie_type: ZOMBIE_BOSS,
            health: 200,
            max_health: 200,
            attack: 25,
            defense: 10,
            xp_reward: 150,
            coin_reward: 100,
        };

        event::emit(ZombieSpawned {
            zombie_type: ZOMBIE_BOSS,
            health: 200,
        });

        transfer::transfer(zombie, tx_context::sender(ctx));
    }

    // Détruire un zombie (appelé après combat)
    public fun destroy_zombie(zombie: Zombie) {
        let Zombie { 
            id, 
            zombie_type, 
            health: _, 
            max_health: _, 
            attack: _, 
            defense: _, 
            xp_reward: _, 
            coin_reward: _ 
        } = zombie;

        event::emit(ZombieDestroyed {
            zombie_type,
        });

        object::delete(id);
    }

    // Getters
    public fun get_health(zombie: &Zombie): u64 {
        zombie.health
    }

    public fun get_max_health(zombie: &Zombie): u64 {
        zombie.max_health
    }

    public fun get_attack(zombie: &Zombie): u64 {
        zombie.attack
    }

    public fun get_defense(zombie: &Zombie): u64 {
        zombie.defense
    }

    public fun get_xp_reward(zombie: &Zombie): u64 {
        zombie.xp_reward
    }

    public fun get_coin_reward(zombie: &Zombie): u64 {
        zombie.coin_reward
    }

    public fun get_type(zombie: &Zombie): u8 {
        zombie.zombie_type
    }
}