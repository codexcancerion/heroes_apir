import 'dart:math';
import 'package:flutter/material.dart';
import 'package:heroes_apir/models/battleground/Card.dart' as BattlegroundCard;
import 'package:heroes_apir/models/battleground/GameEngine.dart';
import 'package:heroes_apir/models/battleground/BattleResult.dart';
import 'package:heroes_apir/db/hero_dao.dart';
import 'package:heroes_apir/screens/game_over.dart';
import 'package:heroes_apir/screens/mainmenu.dart';
import 'package:heroes_apir/widgets/apir_cards_widget.dart';
import 'package:heroes_apir/widgets/small_hero_card.dart';
import '../widgets/dice.dart'; // Import the DiceWidget

class Battleground extends StatefulWidget {
  const Battleground({super.key});

  @override
  _BattlegroundState createState() => _BattlegroundState();
}

class _BattlegroundState extends State<Battleground> {
  final HeroDao _heroDao = HeroDao();
  late GameEngine _gameEngine;
  bool _isLoading = true;
  String? _battleResultMessage;
  BattleResult? _lastBattleResult;
  BattlegroundCard.Card? _selectedPlayerCard;
  int _round = 1;
  bool _isRoundComplete = false; // Track if the round is complete
  bool _isWinnerTextVisible = false; // State variable to control visibility of the winner text

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<BattlegroundCard.Card> cardPool = [];
      for (int i = 0; i < 400; i++) {
        final randomId = Random().nextInt(737) + 1;
        final hero = await _heroDao.getHeroById(randomId);
        if (hero != null) {
          cardPool.add(BattlegroundCard.Card(hero: hero, id: hero.id));
        }
      }

      _gameEngine = GameEngine(cardPool);
      _gameEngine.setupGame();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _playRound() {
    if (_gameEngine.player.deck.isEmpty || _gameEngine.computer.deck.isEmpty) {
      final winner = _gameEngine.player.deck.isEmpty
          ? 'Computer Wins the Game!'
          : 'Player Wins the Game!';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameOverScreen(winner: winner, onRestart: _restartGame),
        ),
      );
      return;
    }

    if (_selectedPlayerCard == null) {
      setState(() {
        _battleResultMessage = 'Please select a card to play!';
      });
      return;
    }

    setState(() {
      final computerCard = _gameEngine.computer.deck.removeAt(0);

      _lastBattleResult = _gameEngine.playRound(
        _selectedPlayerCard!,
        computerCard,
      );

      _gameEngine.player.deck.remove(_selectedPlayerCard);
      _selectedPlayerCard = null;
      _isRoundComplete = true; // Mark the round as complete

      // Reset winner text visibility and trigger delayed display
      _isWinnerTextVisible = false;
      _showWinnerTextWithDelay();
    });
  }

  void _showWinnerTextWithDelay() {
    // Delay the visibility of the winner text until after the ApirCardsWidget animations
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isWinnerTextVisible = true;
        });
      }
    });
  }

  void _nextRound() {
    if (_gameEngine.player.deck.isEmpty || _gameEngine.computer.deck.isEmpty) {
      final winner = _gameEngine.player.deck.isEmpty
          ? 'Computer Won the Game!'
          : 'You Won the Game!';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameOverScreen(winner: winner, onRestart: _restartGame),
        ),
      );
      return;
    }

    // Show the DiceWidget modal
    final int randomDiceNumber = Random().nextInt(6) + 1; // Generate a random number between 1 and 6
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Semi-transparent background
            GestureDetector(
              onTap: () => Navigator.of(context).pop(), // Close the dialog on tap
              child: Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent black background
              ),
            ),
            // Centered Dice Widget
            Center(
              child: Material(
                color: Colors.transparent, // Make the dialog background transparent
                child: DiceWidget(
                  diceNumber: randomDiceNumber, // Pass the random dice number
                  onProceed: () {
                    Navigator.of(context).pop(); // Close the modal
                    setState(() {
                      // Determine the winner of the last round
                      if (_lastBattleResult != null) {
                        if (_lastBattleResult!.winner == 'player') {
                          // Draw diceNumber cards and add them to the player's deck
                          for (int i = 0; i < randomDiceNumber; i++) {
                            if (_gameEngine.cardPool.isNotEmpty) {
                              _gameEngine.player.deck.add(
                                _gameEngine.cardPool.removeAt(0),
                              );
                            }
                          }
                        } else if (_lastBattleResult!.winner == 'computer') {
                          // Draw diceNumber cards and add them to the computer's deck
                          for (int i = 0; i < randomDiceNumber; i++) {
                            if (_gameEngine.cardPool.isNotEmpty) {
                              _gameEngine.computer.deck.add(
                                _gameEngine.cardPool.removeAt(0),
                              );
                            }
                          }
                        }
                      }

                      _battleResultMessage = null;
                      _lastBattleResult = null;
                      _isRoundComplete = false; // Reset for the next round
                      _round++;
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _restartGame() {
    if (!mounted) return; // Ensure the widget is still in the tree
    setState(() {
      _battleResultMessage = null;
      _lastBattleResult = null;
      _selectedPlayerCard = null;
      _round = 1;
      _isRoundComplete = false;
      _isLoading = true;
    });
    _initializeGame();
  }
void _showPlayerDeckModal() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          // Sort the player's deck by total power in descending order
          final sortedDeck = _gameEngine.player.deck
            ..sort((a, b) => b.hero.powerStats.totalScore().compareTo(a.hero.powerStats.totalScore()));

          return Container(
            padding: const EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Deck',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: sortedDeck.map((card) {
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _selectedPlayerCard = card;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: SmallHeroCard(
                              hero: card.hero,
                              isSelected: _selectedPlayerCard == card,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedPlayerCard != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the modal
                        _playRound(); // Play the round
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded square corners
                        ),
                      ),
                      child: const Text('Play'),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battleground'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart Game',
            onPressed: _restartGame,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                // Make the page scrollable
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Computer's Deck and Card Count
                    _buildDeckSection(
                      'Computer',
                      _gameEngine.computer.deck.length,
                    ),
                    const SizedBox(height: 16),

                    // Round Counter
                    Column(
                      children: [
                        Text(
                          'ROUND $_round',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!_isRoundComplete)
                          const Text(
                            'Choose your hero!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Battle Result Message
                    if (_battleResultMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          _battleResultMessage!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Selected Cards
                    if (_lastBattleResult != null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isWinnerTextVisible)
                            _lastBattleResult!.winner == 'computer' ? 
                              Text("Winner: Computer",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red
                              ),
                            ) : Text("Winner: You",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green
                              ),                            
                            ),
                          SizedBox(
                            height: 270, // Provide a fixed height
                            child: ApirCardsWidget(
                              firstCard: _lastBattleResult!.opponentCard,
                              secondCard: _lastBattleResult!.playerCard,
                              winner: _lastBattleResult!.winner == 'computer' ? "first" : "second",
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    const SizedBox(height: 16),

                    // Player's Deck and Card Count
                    _buildDeckSection('Player', _gameEngine.player.deck.length),
                    const SizedBox(height: 16),

                    // Buttons
                    if (!_isRoundComplete)
                      ElevatedButton(
                        onPressed: _showPlayerDeckModal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Choose Hero'),
                      )
                    else
                      ElevatedButton(
                        onPressed: _nextRound,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Next Round'),
                      ),
                  ],
                ),
              ),
              floatingActionButton: MainMenu(),
    );
  }

  Widget _buildDeckSection(String owner, int cardCount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    owner,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 70, // Fixed height for the stacked cards
                    width: 150, // Width to fit the stack
                    child: Stack(
                      children: List.generate(
                        cardCount > 10 ? 10 : cardCount,
                        (index) {
                          return Positioned(
                            left: index * 10.0, // Offset each card slightly
                            child: Container(
                              width: 40,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue.shade800),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      )
                        // Add a "+X" container if there are more than 8 cards
                        ..addAll(
                          cardCount > 10
                              ? [
                                  Positioned(
                                    left: 10 * 10.0, // Position the "+X" container
                                    child: Container(
                                      width: 40,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue.shade800,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+${cardCount - 10}', // Remaining card count
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                              : [],
                        ),
                    ),
                  ),
                  // Card Count
                  Text(
                    '$cardCount Cards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
