import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:heroes_apir/db/hero_dao.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/widgets/small_hero_card.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize the audio player
  final HeroDao _heroDao = HeroDao(); // Initialize HeroDao
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  List<HeroModel> _heroes = []; // List to store heroes
  int _visibleItems = 0; // Tracks the number of visible items (text + heroes)

  final List<Widget> _staticContent = []; // List to store static content widgets

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Define a fade-in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Add static content to the list
    _staticContent.addAll([
      const Text(
        "About the App:",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        "Heroes Apir is a battleground simulator where heroes compete in epic battles. "
        "Each hero has unique stats, abilities, and backstories, making every battle exciting and unpredictable.",
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 32),
      const Text(
        "Links:",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: () {
          debugPrint("GitHub link tapped");
        },
        child: const Text(
          "GitHub: https://github.com/codexcancerion/heroes_apir",
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      const SizedBox(height: 32),
      const Text(
        "Developers:",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
    ]);

    // Fetch heroes, start the animation, and play the sound
    _fetchHeroes();
    _playSound();
  }

  Future<void> _fetchHeroes() async {
    // Fetch heroes with IDs 732-737 from the database
    final heroes = await _heroDao.getAllHeroes();
    setState(() {
      _heroes = heroes.where((hero) => hero.id >= 732 && hero.id <= 737).toList();
    });

    // Start the animation to display all items (static content + heroes)
    _startAnimation();
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/floating-cat.mp3')); // Play the sound
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _startAnimation() async {
    final totalItems = _staticContent.length + _heroes.length;

    for (int i = 1; i <= totalItems; i++) {
      await Future.delayed(const Duration(milliseconds: 500)); // Delay between items
      setState(() {
        _visibleItems = i; // Increment the number of visible items
      });
      _controller.forward(from: 0.0); // Restart the fade animation for each item
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose(); // Dispose of the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(_visibleItems, (index) {
                if (index < _staticContent.length) {
                  // Display static content
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: _staticContent[index],
                  );
                } else {
                  // Display hero cards
                  final heroIndex = index - _staticContent.length;
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SmallHeroCard(hero: _heroes[heroIndex]),
                    ),
                  );
                }
              }),
              const SizedBox(height: 32),
              if (_visibleItems == _staticContent.length + _heroes.length)
                const Text(
                  "Heroes Apir, Copyright 2025",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
      ),
    );
  }
}