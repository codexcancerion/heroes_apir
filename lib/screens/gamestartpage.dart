import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heroes_apir/db/database.dart';
import 'package:heroes_apir/screens/homepage.dart';
import 'package:heroes_apir/utils/api.dart';

class GameStartPage extends StatefulWidget {
  const GameStartPage({Key? key}) : super(key: key);

  @override
  _GameStartPageState createState() => _GameStartPageState();
}

class _GameStartPageState extends State<GameStartPage> {
  final DatabaseManager _dbManager = DatabaseManager.instance;
  final SuperheroApi _api = SuperheroApi();
  final List<String> _loadingMessages = [
    "Loading heroes...",
    "Assembling the Justice League...",
    "Calling the Avengers...",
    "Powering up the Bat-Signal...",
    "Scanning for supervillains...",
    "Preparing your hero database...",
  ];
  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    _startLoadingSequence();
  }

  // Rotates loading messages sequentially and navigates after all messages are shown
  void _startLoadingSequence() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _currentMessageIndex++;
      });

      if (_currentMessageIndex >= _loadingMessages.length) {
        timer.cancel();
        await _checkAndFetchHeroes(); // Ensure heroes are loaded
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    });
  }

  // Checks the database for heroes and fetches them from the API if none exist
  Future<void> _checkAndFetchHeroes() async {
    final dbHeroes = await _dbManager.database;
    final heroes = await dbHeroes.query('heroes');

    if (heroes.isEmpty) {
      // No heroes in the database, fetch from API
      final fetchedHeroes = await _api.fetchAllHeroes(startId: 1, endId: 150);
      for (var hero in fetchedHeroes) {
        await _dbManager.saveHero(hero);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated loading spinner with a fun superhero icon
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.blue.shade700,
                  strokeWidth: 6,
                ),
                Icon(
                  Icons.flash_on, // Fun superhero-like icon
                  color: Colors.yellow.shade700,
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Display current loading message with modern styling
            Text(
              _loadingMessages[_currentMessageIndex % _loadingMessages.length],
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Add a fun tagline below the loading message
            const Text(
              "Your superhero adventure is about to begin!",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}