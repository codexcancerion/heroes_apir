import 'package:flutter/material.dart';
import 'package:heroes_apir/screens/gamestartpage.dart';
import 'screens/homepage.dart'; // Import the HomePage
import 'db/database.dart'; // Import the DatabaseManager
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import sqflite_common_ffi for databaseFactoryFfi

void main() async {
  databaseFactory = databaseFactoryFfi;
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await DatabaseManager.instance.database; // Initialize the database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heroes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heroes App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                      color: ColorScheme.fromSeed(seedColor: Colors.blue).primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: ColorScheme.fromSeed(seedColor: Colors.blue).secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome, Hero!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Choose your path...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Menu Items
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_martial_arts),
              title: const Text('Battle Ground'),
              onTap: () {
                // Navigate to Battle Ground screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Bookmarks'),
              onTap: () {
                // Navigate to Bookmarks screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Hero of the Day'),
              onTap: () {
                // Navigate to Hero of the Day screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                // Navigate to Search screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle logout functionality
              },
            ),
          ],
        ),
      ),
      body: HomePage(), // Default body content
    );
  }
}
