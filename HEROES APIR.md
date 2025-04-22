# **HEROES APIR**

## *A Flutter-based strategic deck-building game using the SuperHero API.*

---

## **OVERVIEW**

The app is a turn-based card battle game where players and the computer select superheroes to fight using stats like intelligence, strength, and speed. The winner of each round draws an additional card from a master deck. The game continues until one party runs out of cards. It also supports bookmarking heroes, tracking gameplay statistics, and browsing hero profiles.  
---

## **FEATURES**

### **Core Gameplay Features:**

* Shuffle a pool of 100 superheroes for each game.  
* Both the player and the computer pick 5 cards.  
* Each round, players select one card to battle.  
* Cards battle based on 6 powerstats.  
* Winner of each round gains an extra card from the pool.  
* Game ends when one side has no cards left.

### **Player System:**

* Player logs in using a token (SuperHero API key).  
* Token stored securely using `SharedPreferences`.  
* Option to log out and clear local session.

### **Hero Management:**

* Bookmark favorite heroes.  
* View detailed hero profiles (stats, biography, appearance).  
* Hero of the Day: Randomly featured hero with full info.

### **Navigation & Utilities:**

* Drawer menu for all key features:  
  * Hero of the Day  
  * Battleground  
  * Bookmarks  
  * Search  
  * About Us  
  * Logout

### **Game Metrics:**

* Save and display:  
  * Wins / Losses  
  * Most used heroes  
  * Heroes with highest win/loss ratio

---

## **FUNCTIONAL REQUIREMENTS**

| ID | Category | Requirement |
| ----- | ----- | ----- |
| FR-01 | Auth | Allow player to input SuperHero API token. |
| FR-02 | Auth | Store token in `SharedPreferences`. |
| FR-03 | Auth | Support logout and preference reset. |
| FR-04 | Data | Fetch superhero data via SuperHero API. |
| FR-05 | Data | Save API data into SQLite. |
| FR-06 | Data | Load from SQLite if data already exists. |
| FR-07 | Data | Allow searching heroes by name. |
| FR-08 | Game Setup | Shuffle and pick 100 cards from the dataset. |
| FR-09 | Game Setup | Allow each player to pick 5 cards. |
| FR-10 | Gameplay | Enable both sides to pick one card per round. |
| FR-11 | Gameplay | Compare 6 traits and declare the winner. |
| FR-12 | Gameplay | Add one new card to the winner from the deck. |
| FR-13 | Gameplay | Game ends when a player has 0 cards. |
| FR-14 | Stats | Record wins, losses, and hero usage. |
| FR-15 | Stats | View stats on most-used/winning heroes. |
| FR-16 | Bookmarks | Bookmark/unbookmark heroes. |
| FR-17 | Bookmarks | Store bookmarks in SQLite. |
| FR-18 | Bookmarks | Display full info of bookmarked heroes. |

---

## **SYSTEM DESIGN**

### **1\. Workflows / Game Flow Diagram**

| ID | Diagram Name | Description |
| ----- | ----- | ----- |
| SD-01 | Game Flow Diagram | Shows login, token validation, deck generation, round play, win/loss states. |
| SD-02 | Player Flow Diagram | Details player interactions such as selecting cards, bookmarking heroes, viewing stats. |

---

### **🧠 2\. UML Diagrams**

**Purpose:** Define structural and behavioral relationships between core system components.

**Deliverables:**

| ID | UML Diagram | Description |
| ----- | ----- | ----- |
| SD-03 | Use Case Diagram | Visual map of system interactions: Player vs Computer, Login, Battle, Bookmark, Stats. |
| SD-04 | Class Diagram | **🔹 `Hero`** Contains all the information fetched from the SuperHero API **Attributes:** `int id String name String fullName String alterEgos List<String> aliases String placeOfBirth String firstAppearance String publisher String alignment String gender String race List<String> height List<String> weight String eyeColor String hairColor String occupation String base String groupAffiliation String relatives String imageUrl` **Relationships:** *used by* → `Card`  **🔹 `Card`** Game abstraction of a `Hero`, only containing powerstats and reference to the full hero profile. **Attributes:** `int id` *(maps to Hero.id)* `int intelligence int strength int speed int durability int power int combat Hero hero` **Relationships:** *has one* → `Hero` *used by* → `Player`, `BattleManager`, `BookmarkManager`  **🔹 `Player` Attributes:** `String name List<Card> deck List<Card> hand int winCount int lossCount`  **🔹 `BattleManager` Attributes:** `Player player Player computer List<Card> gameDeck Card currentPlayerCard Card currentComputerCard`  **🔹 `BattleEngine` Methods:** `int compareCards(Card a, Card b) Map<String, int> evaluateStats(Card a, Card b)`  **🔹 `BookmarkManager` Attributes:** `List<Card> bookmarks`  **🔹 `HeroService` Methods:** `Future<Hero> getHeroById(int id) Future<List<Hero>> searchHero(String name) Future<List<Hero>> fetchAllHeroes()`  **🔹 `LocalDatabase` Methods:** `void saveCard(Card card) void saveHero(Hero hero) void saveBookmark(Card card) void saveGameStats(Player player) List<Card> loadBookmarkedCards() List<Hero> loadHeroes()`  **🔹 `GameStats` Attributes:** `String heroName int totalWins int totalLosses int timesPlayed`  **🔹 `AuthManager` Attributes:** `String token`  **🔹 `UI Screens` (controllers/widgets)** `LoginScreen MainMenuScreen BattleGroundScreen BookmarkScreen HeroDetailScreen HeroOfTheDayScreen SearchScreen StatsScreen`  |
| SD-05 | Sequence Diagram | Shows communication between player, system, and database during one battle round. |

---

### **🔄 3\. Data Flow Diagrams (DFD)**

**Purpose:** Show how data moves between system processes, external APIs, and storage layers.

**Deliverables:**

| ID | DFD Level | Description |
| ----- | ----- | ----- |
| SD-06 | DFD Level 0 | Abstract flow between Player, API, App, and SQLite. |
| SD-07 | DFD Level 1 | Detailed breakdown: Token storage, data fetch, caching, game mechanics, stats tracking. |

---

### **📱 4\. UI Screen Mockups**

**Purpose:** Blueprint of each screen’s layout and how components should behave.

**Deliverables:**

| ID | Screen Name | Key Widgets |
| ----- | ----- | ----- |
| UI-01 | Login Screen | `TextField`, `Button`, `Snackbar`, `SharedPreferences` logic |
| UI-02 | Battle Ground | `GridView`, `Card`, `AnimatedSwitcher`, `HeroCardWidget`, `Dialog` |
| UI-03 | Bookmark Screen | `ListView`, `Dismissible`, `Image`, `Text`, `Delete Button` |
| UI-04 | Hero of the Day | `Card`, `Image`, `Powerstats Chart`, `Info Panels` |
| UI-05 | Statistics | `BarChart`, `PieChart`, `ListTiles`, Hero win/loss counters |
| UI-06 | Search Screen | `SearchBar`, `ListView`, result tiles with image and info |
| UI-07 | Drawer Menu | `Drawer`, `ListTile`, `Icons`, `Logout handler` |

---

### **🧱 5\. Widget and Component Design**

**Purpose:** Define reusable components for consistent and scalable UI.

**Deliverables:**

| ID | Widget Name | Usage |
| ----- | ----- | ----- |
| W-01 | `HeroCardWidget` | Displays hero image \+ powerstats; used in deck/battle view. |
| W-02 | `StatComparisonBar` | Visual stat comparison between two heroes. |
| W-03 | `BookmarkTile` | Hero tile used in bookmarks. |
| W-04 | `BattleLogCard` | Round log for winner, stats, and card used. |
| W-05 | `HeroDetailPanel` | Shows biography, appearance, work, etc. for a hero. |
| W-06 | `VictoryDialog` | Displays round win or final victory message. |

---

### **🗃️ 6\. Local Database Schema (SQLite)**

**Purpose:** Define data models and relationships stored locally.

**Deliverables:**

| Table Name | Fields |
| ----- | ----- |
| `heroes` | `id`, `name`, `powerstats`, `appearance`, `image_url`, etc. |
| `bookmarks` | `id`, `hero_id`, `date_bookmarked` |
| `stats` | `id`, `hero_id`, `wins`, `losses`, `last_used` |
| `game_logs` | `id`, `round`, `player_card`, `computer_card`, `winner_id` |

---

### **🔐 7\. State Management Blueprint**

**Purpose:** Define how app state is controlled across different screens.

**Deliverables:**

| Approach | Areas of Usage |
| ----- | ----- |
| `Provider` or `Riverpod` | Token, Deck, Hero list, Game state |
| `ChangeNotifier` | Battle logic, Card selection, Bookmark toggle |

---

### **⚙️ 8\. API Integration Plan**

**Purpose:** Document how and where each API call will be used.

**Deliverables:**

| Endpoint | Usage |
| ----- | ----- |
| `/search/name` | Hero search functionality |
| `/id/powerstats` | Battle logic and display |
| `/id/biography` | Hero info panel |
| `/id/image` | All image displays |
| `/id/appearance`, `/id/work` | Hero of the Day \+ detail views |

