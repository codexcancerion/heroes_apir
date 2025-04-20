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
      appBar: AppBar(title: Text('Heroes App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Heroes App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Explore the world of superheroes and learn more about their powers, appearances, and connections.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<HeroModel>>(
                future: _dbManager.getAllHeroes(), // Fetch the heroes
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for the response
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show an error message if something goes wrong
                    return Center(
                      child: Text(
                        'Failed to load heroes: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    // Show the list of heroes when data is available
                    final heroes = snapshot.data!;
                    return ListView.builder(
                      itemCount: heroes.length,
                      itemBuilder: (context, index) {
                        final hero = heroes[index];
                        return HeroCardWidget(hero: hero);
                      },
                    );
                  } else {
                    // Handle the case where no data is available
                    return Center(
                      child: Text('No heroes found.'),
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
