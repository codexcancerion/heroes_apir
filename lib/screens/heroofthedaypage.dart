import 'dart:math';
import 'package:flutter/material.dart';
import 'package:heroes_apir/db/database_manager.dart';
import 'package:heroes_apir/db/hero_dao.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/screens/mainmenu.dart';
import 'package:heroes_apir/widgets/hero_details_widget.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class HeroOfTheDayPage extends StatefulWidget {
  const HeroOfTheDayPage({super.key});

  @override
  _HeroOfTheDayPage createState() => _HeroOfTheDayPage();
}

class _HeroOfTheDayPage extends State<HeroOfTheDayPage> {
  final DatabaseManager dbManager = DatabaseManager.instance;
  final HeroDao _heroDao = HeroDao();
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
      final prefs = await SharedPreferences.getInstance();

      // Check if a hero of the day is already saved in SharedPreferences
      final savedHeroId = prefs.getInt('heroOfTheDayId');
      final savedDate = prefs.getString('heroOfTheDayDate');

      // Get the current date in "yyyy-MM-dd" format
      final currentDate = DateTime.now().toIso8601String().split('T').first;

      if (savedHeroId != null && savedDate == currentDate) {
        // If the saved date matches the current date, fetch the saved hero
        final savedHero = await _heroDao.getHeroById(savedHeroId);
        if (savedHero != null) {
          setState(() {
            hero = savedHero;
          });
        } else {
          setState(() {
            _errorMessage = 'Saved hero not found in the database.';
          });
        }
      } else {
        // Generate a new hero of the day
        final randomId = Random().nextInt(731) + 1;
        final fetchedHero = await _heroDao.getHeroById(randomId);

        if (fetchedHero != null) {
          setState(() {
            hero = fetchedHero;
          });

          // Save the hero ID and the current date to SharedPreferences
          await prefs.setInt('heroOfTheDayId', randomId);
          await prefs.setString('heroOfTheDayDate', currentDate);
        } else {
          setState(() {
            _errorMessage = 'Hero not found in the database.';
          });
        }
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