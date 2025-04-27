import 'package:heroes_apir/models/battleground/Card.dart';

class BattleResult {
  final Card playerCard;
  final Card opponentCard;
  final String winner; // "player", "computer", or "draw"
  final String reason;

  BattleResult({
    required this.playerCard,
    required this.opponentCard,
    required this.winner,
    required this.reason,
  });
}
