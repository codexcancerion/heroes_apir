import 'package:flutter/material.dart';
import 'package:heroes_apir/db/database.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/utils/api.dart';
import '/widgets/hero_card_widget.dart'; // Assuming this is the correct path for HeroCardWidget

class HomePage extends StatelessWidget {
  final SuperheroApi api = SuperheroApi();
  final DatabaseManager _dbManager = DatabaseManager.instance;

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Heroes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore the list of your favorite superheroes below.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<HeroModel>>(
                future: _dbManager.getAllHeroes(), // Fetch the heroes
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
                            'Failed to load heroes.',
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
                    // Show the list of heroes when data is available
                    final heroes = snapshot.data!;
                    return ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false, // Disable scrollbars
                      ),
                      child: ListView.builder(
                        itemCount: heroes.length,
                        itemBuilder: (context, index) {
                          final hero = heroes[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: HeroCardWidget(hero: hero),
                          );
                        },
                      ),
                    );
                  } else {
                    // Handle the case where no data is available
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                            size: 50,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No heroes found.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Try adding some heroes to your collection.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
