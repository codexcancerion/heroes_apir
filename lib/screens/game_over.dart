import 'package:flutter/material.dart';
import 'package:heroes_apir/screens/battleground.dart';
import 'package:heroes_apir/screens/mainmenu.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package

class GameOverScreen extends StatefulWidget {
  final String winner;
  final VoidCallback onRestart;

  const GameOverScreen({
    super.key,
    required this.winner,
    required this.onRestart,
  });

  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize the audio player

  @override
  void initState() {
    super.initState();
    _playGameOverSound(); // Play the sound when the screen is displayed
  }

  Future<void> _playGameOverSound() async {
    try {
      if (widget.winner.contains('Computer')) {
        // Play the "battle-lost" sound if the computer won
        await _audioPlayer.play(AssetSource('sounds/battle-lost.mp3'));
      } else {
        // Play the "battle-win" sound if the player won
        await _audioPlayer.play(AssetSource('sounds/battle-win.mp3'));
      }
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the player won
    final bool isPlayerWinner = widget.winner.contains('You');

    return Scaffold(
      appBar: AppBar(title: const Text('Game Over')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display Trophy or Sad Emoji
            Icon(
              isPlayerWinner ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 150, // Large size
              color: isPlayerWinner ? Colors.amber : Colors.red, // Gold for trophy, red for sad emoji
            ),
            const SizedBox(height: 16),

            // Winner Text
            Text(
              widget.winner,
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
                    builder: (context) => Battleground(),
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
                  borderRadius: BorderRadius.circular(12), // Rounded square corners
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