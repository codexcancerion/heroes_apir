import 'package:flutter/material.dart';
import 'package:heroes_apir/screens/battleground.dart';
import 'package:heroes_apir/screens/mainmenu.dart';

class GameOverScreen extends StatelessWidget {
  final String winner;
  final VoidCallback onRestart;

  const GameOverScreen({
    super.key,
    required this.winner,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if the player won
    final bool isPlayerWinner = winner.contains('You');

    return Scaffold(
      appBar: AppBar(title: const Text('Game Over')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display Trophy or Sad Emoji
            Icon(
              isPlayerWinner
                  ? Icons.emoji_events
                  : Icons.sentiment_dissatisfied,
              size: 150, // Large size
              color:
                  isPlayerWinner
                      ? Colors.amber
                      : Colors.red, // Gold for trophy, red for sad emoji
            ),
            const SizedBox(height: 16),

            // Winner Text
            Text(
              winner,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Restart Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Battleground(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Rounded square corners
                ),
              ),
              child: const Text('Restart Game'),
            ),
          ],
        ),
      ),
      floatingActionButton: MainMenu(),
    );
  }
}
