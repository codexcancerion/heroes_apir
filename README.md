# HEROES APIR

Heroes Apir is a turn-based card battle game where players and the computer select superheroes to fight using stats like intelligence, strength, and speed. The winner of each round draws an additional card from a master deck. The game continues until one party runs out of cards. The app also supports bookmarking heroes, tracking gameplay statistics, and browsing hero profiles.

---
## Downloads
1. [Android APK](https://github.com/codexcancerion/heroes_apir/releases/download/v1.1.0/app-release-v1.1.0.apk)
2. [Windows EXE](https://github.com/codexcancerion/heroes_apir/releases/download/v1.1.0/app-release-windows-v1.1.0.exe)

---

## **Table of Contents**
1. [Overview](#overview)
2. [Features](#features)
3. [System Design](#system-design)
4. [Technical Details](#technical-details)
5. [Setup and Installation](#setup-and-installation)
6. [API Integration](#api-integration)
7. [Known Issues](#known-issues)
8. [Future Enhancements](#future-enhancements)

---

## **Overview**

Heroes Apir is a Flutter-based strategic deck-building game that uses the SuperHero API to fetch superhero data. Players compete in a series of battles, selecting cards from their decks to compare stats. The game is designed to be engaging, with features like animations and hero bookmarks.

---

## **Features**

### **Core Gameplay Features**
- **Turn-Based Battles**: Players and the computer take turns selecting cards to battle.
- **Stat Comparison**: Compare six traits (intelligence, strength, speed, durability, power, combat) to determine the winner.
- **Dynamic Deck Management**: Winners draw additional cards from the master deck.

### **Hero Management**
- **Bookmark Heroes**: Save favorite heroes for quick access.
- **Hero Profiles**: View detailed information about each hero, including stats, biography, and appearance.

### **Navigation & Utilities**
- **Hero of the Day**: Display a randomly selected hero each day.
- **Search Functionality**: Search for heroes by name.
- **Sound Effects**: Play sound effects during gameplay for an immersive experience.

---

## **System Design**

### **1. Workflows / Game Flow Diagram**
- **Login**: Validate API token and load data.
- **Deck Generation**: Shuffle and distribute cards to players.
- **Gameplay**: Players select cards, compare stats, and determine the winner.
- **Game End**: The game ends when one player runs out of cards.

### **2. Data Structures**
- **Class Structure**:
  - **Hero**: Contains all information fetched from the SuperHero API.
  - **Card**: Represents a hero in the game, focusing on power stats.
  - **Player**: Manages the player's deck and hand.
  - **GameEngine**: Handles game logic, including card shuffling and stat comparison.

### **3. Data Flow**
- **Level 0**: Abstract flow between Player, API, App, and SQLite.
- **Level 1**: Detailed breakdown of token storage, data fetch and game mechanics.


### **4. Screens/Pages**
| Screen Name         | 
|--------------------------------------------------|
| Login Screen        | 
| Battle Ground       | 
| Bookmark Screen     | 
| Hero of the Day     | 
| Statistics          | 
| Search Screen       | 

---

## **Technical Details**

### **Tech Stack**
- **Frontend**: Flutter
- **Backend**: SuperHero API (via proxy)
- **Database**: SQLite (via `sqflite` package)

### **Key Packages**
| Package             | Usage                                            |
|---------------------|--------------------------------------------------|
| `audioplayers`      | Play sound effects during gameplay.              |
| `shared_preferences`| Store user preferences and API tokens.           |
| `sqflite`           | Local database for storing heroes and stats.     |
| `url_launcher`      | Open external links in the browser.              |

### **Folder Structure**


   ```bash
   lib/ 
   ├── models/ # Data models (HeroModel, Card, Player) 
   ├── db/ # Database access objects (HeroDao, BookmarkDao) 
   ├── screens/ # UI screens (BattleGround, AboutUs, HeroOfTheDay) 
   ├── widgets/ # Reusable widgets (SmallHeroCard, PowerStatsWidget)
```
