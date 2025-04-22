import 'dart:math';
import 'package:flutter/material.dart';
import 'package:heroes_apir/db/database_manager.dart';
import 'package:heroes_apir/db/hero_dao.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/screens/mainmenu.dart';
import 'package:heroes_apir/widgets/lucky_text.dart';
import '/widgets/hero_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
        final hero = await _heroDao.getHeroById(randomId); // Fetch hero from the database
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
    } catch (e) {
      print('Error fetching heroes: $e');
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
      appBar: AppBar(
        title: LuckyText(
          text: "HEROES APIR",
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: _heroes.isEmpty && _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _heroes.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _heroes.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      // child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: HeroCardWidget(hero: _heroes[index]),
                );
              },
            ),
      floatingActionButton: MainMenu(),
    );
  }
}
