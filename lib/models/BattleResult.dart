import 'package:heroes_apir/models/CardModel.dart';

class BattleResult {
  final CardModel playerCard;
  final CardModel opponentCard;
  final String winner; // "player", "computer", or "draw"
  final String reason;

  BattleResult({
    required this.playerCard,
    required this.opponentCard,
    required this.winner,
    required this.reason,
  });
}
