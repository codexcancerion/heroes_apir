import 'dart:math';
import 'package:flutter/material.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/screens/mainmenu.dart';
import 'package:heroes_apir/utils/api.dart';
import 'package:heroes_apir/widgets/hero_details_widget.dart';

class HeroOfTheDayPage extends StatefulWidget {
  const HeroOfTheDayPage({Key? key}) : super(key: key);

  @override
  _HeroOfTheDayPage createState() => _HeroOfTheDayPage();
}

class _HeroOfTheDayPage extends State<HeroOfTheDayPage> {
  final SuperheroApi api = SuperheroApi();
  HeroModel? hero;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchHeroOfTheDay();
  }

  Future<void> _fetchHeroOfTheDay() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Generate a random number between 1 and 731
      final randomId = Random().nextInt(731) + 1;

      // Fetch the hero by ID
      final heroes = await api.fetchHeroById(randomId.toString());
      if (heroes.isNotEmpty) {
        setState(() {
          hero = heroes.first;
        });
      } else {
        setState(() {
          _errorMessage = 'Hero not found.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch hero of the day: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero of the Day'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : hero != null
                  ? HeroDetailsWidget(hero: hero!)
                  : const Center(
                      child: Text(
                        'No hero found.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
      floatingActionButton: MainMenu(),
    );
  }
}
