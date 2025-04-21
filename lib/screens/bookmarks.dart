import 'package:flutter/material.dart';
import 'package:heroes_apir/db/database.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/widgets/hero_card_widget.dart';

class BookmarksPage extends StatelessWidget {
  final DatabaseManager _dbManager = DatabaseManager.instance;

  BookmarksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookmarked Heroes',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<int>>(
          future: _dbManager.getBookmarks(), // Fetch bookmarked hero IDs
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for the response
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // Show an error message if something goes wrong
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load bookmarks.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // Show the list of bookmarked heroes when data is available
              final bookmarkedHeroIds = snapshot.data!;
              return FutureBuilder<List<HeroModel>>(
                future: _fetchBookmarkedHeroes(bookmarkedHeroIds),
                builder: (context, heroSnapshot) {
                  if (heroSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (heroSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading heroes: ${heroSnapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (heroSnapshot.hasData && heroSnapshot.data!.isNotEmpty) {
                    final heroes = heroSnapshot.data!;
                    return ListView.builder(
                      itemCount: heroes.length,
                      itemBuilder: (context, index) {
                        final hero = heroes[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: HeroCardWidget(hero: hero),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No bookmarked heroes found.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    );
                  }
                },
              );
            } else {
              // Handle the case where no bookmarks are found
              return const Center(
                child: Text(
                  'No bookmarked heroes yet.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<HeroModel>> _fetchBookmarkedHeroes(List<int> heroIds) async {
    List<HeroModel> heroes = [];
    for (int id in heroIds) {
      final hero = await _dbManager.getHeroById(id);
      if (hero != null) {
        heroes.add(hero);
      }
    }
    return heroes;
  }
}