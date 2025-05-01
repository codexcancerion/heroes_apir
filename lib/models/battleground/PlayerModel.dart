

import 'package:heroes_apir/models/battleground/Card.dart';

class PlayerModel {
  final String name;
  List<Card> deck;
  List<Card> hand;
  List<Card> wonCards;

  PlayerModel({
    required this.name,
    required this.deck,
    required this.hand,
    this.wonCards = const [],
  });

  void drawCard(Card card) {
    hand.add(card);
  }

  void winCard(Card card) {
    wonCards.add(card);
  }

  bool hasCards() => hand.isNotEmpty;

  
  void removeCardOnDeckByIndex(int index) {
    if (index >= 0 && index < deck.length) {
      deck.removeAt(index);
    } else {
      throw RangeError('Index out of range: $index');
    }
  }
}
