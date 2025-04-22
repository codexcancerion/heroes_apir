import 'package:heroes_apir/models/HeroModel.dart';

class Card {
  final int id;
  final HeroModel hero;

  Card({
    required this.id,
    required this.hero,
  });
}