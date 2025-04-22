import 'package:flutter/material.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/screens/mainmenu.dart';
import 'package:heroes_apir/widgets/hero_details_widget.dart'; 

class HeroFullInformation extends StatelessWidget {
  final HeroModel hero;

  const HeroFullInformation({Key? key, required this.hero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Information'),
      ),
      body: HeroDetailsWidget(hero: hero),
      floatingActionButton: MainMenu(),
    );
  }
}
