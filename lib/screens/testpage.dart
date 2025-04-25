import 'dart:math';
import 'package:flutter/material.dart';
import 'package:heroes_apir/db/hero_dao.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/widgets/small_hero_card.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final HeroDao _heroDao = HeroDao();
  List<HeroModel> _heroes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRandomHeroes();
  }

  Future<void> _fetchRandomHeroes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<HeroModel> heroes = [];
      for (int i = 0; i < 10; i++) {
        final randomId = Random().nextInt(731) + 1; // Random ID between 1 and 731
        final hero = await _heroDao.getHeroById(randomId);
        if (hero != null) {
          heroes.add(hero);
        }
      }

      setState(() {
        _heroes = heroes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _heroes.length,
              itemBuilder: (context, index) {
                final hero = _heroes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SmallHeroCard(hero: hero),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRandomHeroes,
        tooltip: 'Refresh Heroes',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}