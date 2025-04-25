import 'package:flutter/material.dart';
import 'package:heroes_apir/screens/loginpage.dart';

void main() async {
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
        fontFamily: 'Marcellus',
      ),
      home: const LoginPage(),
    );
  }
}
