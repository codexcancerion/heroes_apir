import 'package:heroes_apir/models/BattleResult.dart';
import 'package:heroes_apir/models/CardModel.dart';
import 'package:heroes_apir/models/PlayerModel.dart';

class GameEngine {
  final List<CardModel> cardPool;
  late PlayerModel player;
  late PlayerModel computer;

  GameEngine(this.cardPool);

  void setupGame() {
    cardPool.shuffle();
    player = PlayerModel(
      name: 'Player',
      deck: cardPool.sublist(0, 5),
      hand: [],
    );
    computer = PlayerModel(
      name: 'Computer',
      deck: cardPool.sublist(5, 10),
      hand: [],
    );
  }

  BattleResult playRound(CardModel playerCard, CardModel computerCard) {
    int playerScore = playerCard.hero.powerStats.totalScore();
    int computerScore = computerCard.hero.powerStats.totalScore();

    String winner = playerScore > computerScore
        ? 'player'
        : (playerScore < computerScore ? 'computer' : 'draw');

    return BattleResult(
      playerCard: playerCard,
      opponentCard: computerCard,
      winner: winner,
      reason: 'Score: $playerScore vs $computerScore',
    );
  }
}
