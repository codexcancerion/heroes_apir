import 'package:flutter/material.dart';
import 'package:heroes_apir/db/hero_dao.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/models/PowerStats.dart';
import 'package:heroes_apir/widgets/small_hero_card.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final HeroDao _heroDao = HeroDao(); // Initialize HeroDao
  List<HeroModel> _heroes = []; // List to store heroes

  @override
  void initState() {
    super.initState();
    _initializeHeroes(); // Initialize heroes on load
  }

  Future<void> _initializeHeroes() async {
  //   // Define the developers as heroes
  //   final List<HeroModel> developerHeroes = [
  //     HeroModel(
  //       id: 732,
  //       name: "Melbert P. Marafo",
  //       imageUrl: "https://lh3.googleusercontent.com/a/ACg8ocIq6KbIPLB4WEzS1uO82D-g9W_02HncqRkjCYaIWypXVnxqmyI=s96-c?w=96&q=50&fit=max&auto=format%2Ccompress",
  //       powerStats: PowerStats(
  //         intelligence: 95,
  //         strength: 90,
  //         speed: 85,
  //         durability: 90,
  //         power: 100,
  //         combat: 95,
  //       ),
  //       biography: Biography(
  //         fullName: "Melbert P. Marafo",
  //         alterEgos: "The Strategist",
  //         aliases: ["The Best Hero"],
  //         placeOfBirth: "Hero City",
  //         firstAppearance: "Battleground Chronicles #1",
  //         publisher: "Heroes Apir",
  //         alignment: "good",
  //       ),
  //       appearance: Appearance(
  //         gender: "Male",
  //         race: "Human",
  //         height: ["6'2\"", "188 cm"],
  //         weight: ["180 lbs", "82 kg"],
  //         eyeColor: "Brown",
  //         hairColor: "Black",
  //       ),
  //       work: Work(
  //         occupation: "Tactician",
  //         base: "Hero Headquarters",
  //       ),
  //       connections: Connections(
  //         groupAffiliation: "The Elite Heroes",
  //         relatives: "Unknown",
  //       ),
  //     ),
  //     // Other heroes (733 to 737) are defined here...
  //   ];

  //   // Save heroes to the database
  //   for (var hero in developerHeroes) {
  //     await _heroDao.update(hero);
  //   }

  //   // Fetch heroes from the database and filter by ID range
    final heroes = await _heroDao.getAllHeroes();
    setState(() {
      _heroes = heroes.where((hero) => hero.id >= 732 && hero.id <= 737).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Heroes'),
        centerTitle: true,
      ),
      body: _heroes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _heroes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmallHeroCard(hero: _heroes[index]),
                );
              },
            ),
    );
  }
}