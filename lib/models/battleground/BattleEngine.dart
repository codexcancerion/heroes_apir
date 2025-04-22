import 'package:heroes_apir/models/battleground/BattleManager.dart';
import 'package:heroes_apir/models/battleground/Card.dart';

class BattleEngine {
  final BattleManager battleManager;

  BattleEngine({required this.battleManager});

  // Initialize the game with shuffled cards
  void initializeGame(List<Card> allCards) {
    allCards.shuffle();
    battleManager.gameDeck = allCards.sublist(10); // Remaining cards in the deck
    battleManager.player.deck = allCards.sublist(0, 5); // Player's initial deck
    battleManager.computer.deck = allCards.sublist(5, 10); // Computer's initial deck
  }

  // Play a single round
  String playRound(String selectedStat) {
    final playerCard = battleManager.player.hand.removeAt(0);
    final computerCard = battleManager.computer.hand.removeAt(0);

    battleManager.currentPlayerCard = playerCard;
    battleManager.currentComputerCard = computerCard;

    final result = battleManager.compareCards(playerCard, computerCard, selectedStat);

    if (result == 1) {
      // Player wins
      battleManager.addCardToWinner(battleManager.player, computerCard);
      return 'Player wins this round!';
    } else if (result == -1) {
      // Computer wins
      battleManager.addCardToWinner(battleManager.computer, playerCard);
      return 'Computer wins this round!';
    } else {
      // Draw
      return 'It\'s a draw!';
    }
  }

  // Determine the final winner
  String determineWinner() {
    if (battleManager.player.hand.isEmpty) {
      return 'Computer wins the game!';
    } else if (battleManager.computer.hand.isEmpty) {
      return 'Player wins the game!';
    } else {
      return 'Game is still ongoing.';
    }
  }
}