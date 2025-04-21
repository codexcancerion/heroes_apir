import 'package:flutter/material.dart';
import 'package:heroes_apir/screens/loginpage.dart';
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
      home: const LoginPage(),
    );
  }
}
