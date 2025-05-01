import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:heroes_apir/db/hero_dao.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/widgets/small_hero_card.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize the audio player
  final HeroDao _heroDao = HeroDao(); // Initialize HeroDao
  List<HeroModel> _heroes = []; // List to store heroes
  int _visibleStaticItems = 0; // Tracks the number of visible static items
  int _visibleHeroItems = 0; // Tracks the number of visible hero items

  final List<Widget> _staticContent = []; // List to store static content widgets

  @override
  void initState() {
    super.initState();

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
        onTap: () async {
          const url = "https://github.com/codexcancerion/heroes_apir";
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            debugPrint("Could not launch $url");
          }
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

    // Start showing static content and fetch heroes in parallel
    _startStaticContentDisplay();
    _fetchHeroes();
    _playSound();
  }

  Future<void> _fetchHeroes() async {
    try {
      final heroes = await _heroDao.getAllHeroes();
      setState(() {
        _heroes = heroes.where((hero) => hero.id >= 732 && hero.id <= 737).toList();
      });

      // Start showing heroes after fetching
      _startHeroDisplay();
    } catch (e) {
      debugPrint('Error fetching heroes: $e');
    }
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/floating-cat.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _startStaticContentDisplay() async {
    for (int i = 0; i < _staticContent.length; i++) {
      setState(() {
        _visibleStaticItems = i + 1; // Increment the number of visible static items
      });
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _startHeroDisplay() async {
    for (int i = 0; i < _heroes.length; i++) {
      setState(() {
        _visibleHeroItems = i + 1; // Increment the number of visible hero items
      });
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() {
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
              // Display static content
              ...List.generate(_visibleStaticItems, (index) {
                return _staticContent[index];
              }),
              // Display hero cards
              ...List.generate(_visibleHeroItems, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SmallHeroCard(hero: _heroes[index]),
                );
              }),
              const SizedBox(height: 32),
              if (_visibleStaticItems == _staticContent.length &&
                  _visibleHeroItems == _heroes.length)
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