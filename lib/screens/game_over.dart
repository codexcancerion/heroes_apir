import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final String winner;
  final VoidCallback onRestart;

  const GameOverScreen({
    Key? key,
    required this.winner,
    required this.onRestart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              winner,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRestart,
              child: const Text('Restart Game'),
            ),
          ],
        ),
      ),
    );
  }
}