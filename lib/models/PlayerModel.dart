import 'package:heroes_apir/models/CardModel.dart';

class PlayerModel {
  final String name;
  List<CardModel> deck;
  List<CardModel> hand;
  List<CardModel> wonCards;

  PlayerModel({
    required this.name,
    required this.deck,
    required this.hand,
    this.wonCards = const [],
  });

  void drawCard(CardModel card) {
    hand.add(card);
  }

  void winCard(CardModel card) {
    wonCards.add(card);
  }

  bool hasCards() => hand.isNotEmpty;
}
