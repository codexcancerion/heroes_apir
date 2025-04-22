import 'package:heroes_apir/models/battleground/Card.dart';
import 'package:heroes_apir/models/battleground/Player.dart';

class BattleManager {
  final Player player;
  final Player computer;
  List<Card> gameDeck;
  Card? currentPlayerCard;
  Card? currentComputerCard;

  BattleManager({
    required this.player,
    required this.computer,
    required this.gameDeck,
  });

  int compareCards(Card playerCard, Card computerCard, String stat) {
    final playerStat = _getStatValue(playerCard, stat);
    final computerStat = _getStatValue(computerCard, stat);

    if (playerStat > computerStat) {
      return 1;
    } else if (playerStat < computerStat) {
      return -1;
    } else {
      return 0;
    }
  }

  int _getStatValue(Card card, String stat) {
    switch (stat) {
      case 'intelligence':
        return card.hero.powerStats.intelligence;
      case 'strength':
        return card.hero.powerStats.strength;
      case 'speed':
        return card.hero.powerStats.speed;
      case 'durability':
        return card.hero.powerStats.durability;
      case 'power':
        return card.hero.powerStats.power;
      case 'combat':
        return card.hero.powerStats.combat;
      default:
        throw Exception('Invalid stat: $stat');
    }
  }

  void addCardToWinner(Player winner, Card card) {
    winner.addCardToHand(card);
  }

  bool isGameOver() {
    return player.hand.isEmpty || computer.hand.isEmpty;
  }
}