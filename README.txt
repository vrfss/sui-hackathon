# 🧟 ZOMBIE SLAYER - Jeu de Combat sur Blockchain Sui

## 📖 Description

Zombie Slayer est un jeu de plateforme développé sur la blockchain Sui. Incarne un héros qui doit combattre des hordes de zombies pour gagner de l'expérience, monter en niveau et devenir plus puissant !

**Caractéristiques principales :**
- ⚔️ Système de combat stratégique on-chain
- 📈 Progression avec level-up et amélioration des stats
- 🧟 3 types de zombies (Normal, Fort, Boss)
- 💰 Économie avec pièces et système de soin
- 🎮 Interface web interactive
- ⛓️ Tous les combats sont vérifiables sur la blockchain

## 🏗️ Architecture

### Backend (Smart Contracts Move)
- **player.move** : Gestion du personnage joueur (stats, niveau, XP, pièces)
- **zombie.move** : Gestion des zombies et leurs caractéristiques
- **combat.move** : Logique de combat entièrement on-chain

### Frontend (HTML/CSS/JavaScript)
- Interface web responsive
- Intégration avec Sui Wallet
- Affichage en temps réel des stats et combats
- Gestion des transactions blockchain

## 🚀 Installation et Déploiement

### Prérequis
- Sui CLI installé
- Sui Wallet (extension Chrome)
- Compte sur Sui testnet avec des SUI tokens

### Étape 1 : Cloner/Créer le projet
```bash
mkdir zombie-game
cd zombie-game
```

### Étape 2 : Structure des fichiers
```
zombie-game/
├── Move.toml
├── sources/
│   ├── player.move
│   ├── zombie.move
│   └── combat.move
└── index.html
```

### Étape 3 : Compiler les smart contracts
```bash
sui move build
```

### Étape 4 : Déployer sur testnet
```bash
sui client publish --gas-budget 100000000
```

**Important :** Notez le **Package ID** qui s'affiche après le déploiement !

### Étape 5 : Configurer le frontend
Ouvrez `index.html` et remplacez :
```javascript
PACKAGE_ID: 'YOUR_PACKAGE_ID_HERE'
```
par votre vrai Package ID.

### Étape 6 : Lancer le jeu
- Ouvrez `index.html` dans votre navigateur
- Installez Sui Wallet si ce n'est pas déjà fait
- Connectez votre wallet
- Jouez !

## 🎮 Comment Jouer

### 1. Connexion
- Cliquez sur "Connecter Wallet Sui"
- Autorisez l'accès dans votre Sui Wallet
- Votre adresse s'affiche en haut

### 2. Créer un personnage
- Cliquez sur "Créer Personnage"
- Entrez un nom
- Confirmez la transaction dans votre wallet
- Vos stats de départ :
  - 100 HP
  - 10 ATK
  - 5 DEF
  - Level 1
  - 100 pièces

### 3. Combattre des zombies

**Spawner un zombie :**
- Cliquez sur "Spawn Normal/Fort/Boss"
- Confirmez la transaction
- Le zombie apparaît dans la liste de droite

**Attaquer un zombie :**
- Cliquez sur "ATTAQUER" sur un zombie
- Le combat se déroule automatiquement on-chain
- Résultat affiché dans les logs

### 4. Progression
- Gagnez de l'XP en battant des zombies
- Level-up automatique tous les 100 XP
- Vos stats augmentent à chaque niveau
- Utilisez vos pièces pour vous soigner (10 💰 = +50 HP)

## ⚔️ Système de Combat

### Calcul des dégâts
```
Dégâts = Attaque de l'attaquant - Défense du défenseur (minimum 1)
```

### Résolution
Le combat se déroule en tours automatiques jusqu'à ce que l'un des combattants tombe à 0 HP.

Le gagnant est déterminé par :
```
Tours pour tuer l'adversaire = HP adversaire ÷ Dégâts infligés
```

Si vous tuez le zombie avant qu'il ne vous tue → **VICTOIRE** 🎉
Sinon → **DÉFAITE** 💀

### Récompenses par type de zombie

| Type | HP | ATK | DEF | XP | Pièces |
|------|-----|-----|-----|-----|---------|
| Normal | 50 | 8 | 2 | 25 | 10 |
| Fort | 100 | 15 | 5 | 50 | 25 |
| Boss | 200 | 25 | 10 | 150 | 100 |

### Level-Up
Tous les 100 XP, vous montez d'un niveau :
- +20 HP maximum
- Heal complet
- +3 ATK
- +2 DEF

## 🛠️ Fonctionnalités du Code

### Smart Contracts (Move)

**player.move :**
- `create_player(name)` : Créer un nouveau personnage
- `gain_experience(player, xp)` : Gagner de l'XP et level-up
- `take_damage(player, damage)` : Subir des dégâts
- `heal(player, amount)` : Se soigner (coûte 10 pièces)
- `add_coins(player, amount)` : Ajouter des pièces

**zombie.move :**
- `spawn_normal()` : Créer un zombie normal
- `spawn_strong()` : Créer un zombie fort
- `spawn_boss()` : Créer un zombie boss
- `destroy_zombie(zombie)` : Détruire un zombie

**combat.move :**
- `fight(player, zombie)` : Lancer un combat complet
- Émet un événement `CombatFinished` avec les résultats

### Frontend (JavaScript)

**Fonctions principales :**
- `connectWallet()` : Connexion au Sui Wallet
- `createPlayer()` : Transaction pour créer un personnage
- `spawnZombie(type)` : Transaction pour spawner un zombie
- `attackZombie(id)` : Transaction pour combattre
- `loadPlayerData()` : Charger les stats depuis la blockchain
- `loadZombies()` : Charger la liste des zombies

## 📊 Données Blockchain

Toutes les actions du jeu sont enregistrées sur la blockchain Sui :
- Création de personnages
- Spawn de zombies
- Résultats des combats
- Progression des joueurs

Vous pouvez vérifier toutes les transactions sur l'explorateur Sui testnet.

## 🔧 Dépannage

### "Wallet Sui non détecté"
- Installez l'extension Sui Wallet depuis le Chrome Web Store
- Rechargez la page après installation

### "Erreur lors de la création"
- Vérifiez que vous avez des SUI tokens sur testnet
- Obtenez des tokens gratuits sur le faucet Sui testnet

### "Package ID non valide"
- Assurez-vous d'avoir bien remplacé `YOUR_PACKAGE_ID_HERE` par votre vrai Package ID
- Le Package ID doit commencer par `0x`

### Le jeu ne charge pas
- Vérifiez votre connexion internet
- Ouvrez la console du navigateur (F12) pour voir les erreurs
- Vérifiez que Sui testnet est accessible

## 🎯 Stratégies de Jeu

### Pour débutants
1. Commencez par farmer des zombies normaux
2. Montez au moins au niveau 3-4
3. Gardez toujours des pièces pour vous soigner
4. Ne combattez pas avec moins de 30 HP

### Pour intermédiaires
1. Alternez entre zombies forts et normaux
2. Optimisez votre ratio XP/risque
3. Attaquez les boss uniquement avec 80+ HP

### Optimisation
- Un zombie normal rapporte 2.5 XP par pièce
- Un zombie fort rapporte 2 XP par pièce
- Un zombie boss rapporte 1.5 XP par pièce
- **Stratégie optimale** : farmer les zombies normaux pour level-up rapidement !

## 🚧 Améliorations Futures

Idées pour étendre le jeu :
- [ ] Inventaire d'objets (épées, armures)
- [ ] Compétences spéciales et cooldowns
- [ ] Système de craft
- [ ] Marketplace pour échanger des objets
- [ ] Mode multijoueur (PvP)
- [ ] Donjons avec plusieurs vagues de zombies
- [ ] NFTs pour les objets rares
- [ ] Système de guildes
- [ ] Leaderboard global

## 📝 Notes Techniques

- **Langage backend** : Move (pour Sui)
- **Frontend** : HTML5, CSS3, JavaScript (ES6+)
- **Blockchain** : Sui testnet
- **SDK** : @mysten/sui v1.0.0
- **Edition Move** : 2024.beta

## 🤝 Contribution

Ce projet est open source. N'hésitez pas à :
- Forker le projet
- Proposer des améliorations
- Signaler des bugs
- Partager vos idées

## 📜 Licence

Projet créé dans un cadre éducatif.

## 🙏 Remerciements

- Sui Foundation pour la blockchain et le SDK
- Claude AI pour l'assistance au développement
- La communauté Move pour la documentation

---

**Bon jeu et bonne chasse aux zombies ! 🧟⚔️**

Pour toute question : ouvrez une issue sur le repo GitHub du projet.

---

*Version 1.0 - Novembre 2024*