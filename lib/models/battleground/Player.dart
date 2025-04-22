import 'package:heroes_apir/models/battleground/Card.dart';

class Player {
  final String name;
  List<Card> deck; 
  List<Card> hand;
  int winCount;
  int lossCount;

  Player({
    required this.name,
    required this.deck,
    required this.hand,
    this.winCount = 0,
    this.lossCount = 0,
  });

  void addCardToHand(Card card) {
    hand.add(card);
  }

  void removeCardFromHand(Card card) {
    hand.remove(card);
  }
}