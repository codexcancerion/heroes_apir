import 'dart:math';
import 'package:flutter/material.dart';
import 'package:heroes_apir/db/database_manager.dart';
import 'package:heroes_apir/db/hero_dao.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/screens/battleground.dart';
import 'package:heroes_apir/screens/heroofthedaypage.dart';
import 'package:heroes_apir/screens/mainmenu.dart';
import '/widgets/hero_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseManager dbManager = DatabaseManager.instance;
  final ScrollController _scrollController = ScrollController();
  final List<HeroModel> _heroes = [];
  final HeroDao _heroDao = HeroDao();
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchRandomHeroes(); // Fetch initial heroes
    _scrollController.addListener(_onScroll); // Add scroll listener
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  Future<void> _fetchRandomHeroes() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final List<HeroModel> newHeroes = [];
      for (int i = 0; i < 10; i++) {
        final randomId = Random().nextInt(731) + 1; // Generate random ID
        final hero = await _heroDao.getHeroById(
          randomId,
        ); // Fetch hero from the database
        if (hero != null) {
          newHeroes.add(hero);
        }
      }

      setState(() {
        _heroes.addAll(newHeroes);

        // Remove older heroes if the total exceeds 50
        if (_heroes.length > 200) {
          _heroes.removeRange(0, _heroes.length - 200);
        }

        // Stop fetching if no new heroes are added
        if (newHeroes.isEmpty) {
          _hasMore = false;
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchRandomHeroes(); // Fetch more heroes when near the bottom
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _heroes.isEmpty && _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome Message
                    SizedBox(
                      height: 560,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 500,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Replace High-Five Emoji with an Image
                                    Container(
                                      height: 80, // Adjust the height as needed
                                      width: 80,  // Adjust the width as needed
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                          image: AssetImage('assets/icon/app_icon.png'), // Path to the image
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                            
                                    // Title Text
                                    Text(
                                      "Heroes Apir!",
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                            
                                    // Subtitle Text
                                    Text(
                                      "Discover and explore a collection of heroes from the database. "
                                      "Scroll down to see more heroes and learn about their unique abilities.",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                            
                                    // Quick Action Buttons
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 16.0, // Space between buttons horizontally
                                      runSpacing: 16.0, // Space between buttons vertically
                                      children: [
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
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text('Battle Heroes'),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HeroOfTheDayPage(),
                                              ),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(color: Colors.blue.shade700),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text('See Hero of the Day'),
                                        ),
                                      ],
                                    ),
                            
                                    const SizedBox(height: 16),
                                    Text(
                                      "Swipe down to refresh or scroll to load more heroes.",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    // Hero Cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _heroes.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _heroes.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: HeroCardWidget(hero: _heroes[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
      floatingActionButton: MainMenu(),
    );
  }
}
