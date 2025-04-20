import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heroes_apir/db/database.dart';
import 'package:heroes_apir/utils/api.dart';
import 'homepage.dart';

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
    _checkAndFetchHeroes();
  }

  // Rotates loading messages every 1.5 seconds
  void _startLoadingSequence() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _currentMessageIndex =
            (_currentMessageIndex + 1) % _loadingMessages.length;
      });
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

    // Navigate to the HomePage after loading is complete
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated loading spinner
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // Rotating loading messages
            Text(
              _loadingMessages[_currentMessageIndex],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}