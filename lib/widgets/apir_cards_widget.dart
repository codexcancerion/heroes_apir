import 'package:flutter/material.dart';
import 'package:heroes_apir/models/battleground/Card.dart' as BattlegroundCard;
import 'package:heroes_apir/widgets/small_hero_card.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package

class ApirCardsWidget extends StatefulWidget {
  final BattlegroundCard.Card firstCard;
  final BattlegroundCard.Card secondCard;
  final String winner; // Either "first" or "second"

  const ApirCardsWidget({
    super.key,
    required this.firstCard,
    required this.secondCard,
    required this.winner,
  });

  @override
  _ApirCardsWidgetState createState() => _ApirCardsWidgetState();
}

class _ApirCardsWidgetState extends State<ApirCardsWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _firstCardCollisionAnimation;
  late Animation<double> _secondCardCollisionAnimation;
  late Animation<double> _firstCardRestAnimation;
  late Animation<double> _secondCardRestAnimation;

  bool _isFirstCardSelected = false;
  bool _isSecondCardSelected = false;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize the audio player

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Total duration for both animations
    );

    // Define animations for the collision phase (speed up)
    _firstCardCollisionAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn), // First half of the animation
      ),
    );

    _secondCardCollisionAnimation = Tween<double>(begin: 200, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn), // First half of the animation
      ),
    );

    // Define animations for the rest phase (move to resting position)
    _firstCardRestAnimation = Tween<double>(begin: 0, end: -100).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut), // Second half of the animation
      ),
    );

    _secondCardRestAnimation = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut), // Second half of the animation
      ),
    );

    // Add a listener to update the winner's card after the animation completes
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (widget.winner == "first") {
            _isFirstCardSelected = true;
          } else if (widget.winner == "second") {
            _isSecondCardSelected = true;
          }
        });

        // Play the sound if the second card wins
        if (widget.winner == "second") {
          await _audioPlayer.play(AssetSource('sounds/apir-win.wav')); // Ensure the file exists in assets
        } else {
          await _audioPlayer.play(AssetSource('sounds/apir-lose.mp3')); // Ensure the file exists in assets
        }
      }
    });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose(); // Dispose of the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Provide a fixed height
      width: MediaQuery.of(context).size.width, // Provide a fixed width
      child: Stack(
        alignment: Alignment.center,
        children: [
          // First card animation
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Combine collision and rest animations
              final position = _controller.value <= 0.5
                  ? _firstCardCollisionAnimation.value
                  : _firstCardRestAnimation.value;

              return Positioned(
                left: MediaQuery.of(context).size.width / 2 + position - 85,
                child: Transform.scale(
                  scale: _controller.value <= 0.5 ? 0.9 : 0.8, // Scale down slightly in the rest phase
                  child: SmallHeroCard(
                    hero: widget.firstCard.hero,
                    isSelected: _isFirstCardSelected, // Initially false, updated after animation
                  ),
                ),
              );
            },
          ),
          // Second card animation
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Combine collision and rest animations
              final position = _controller.value <= 0.5
                  ? _secondCardCollisionAnimation.value
                  : _secondCardRestAnimation.value;

              return Positioned(
                right: MediaQuery.of(context).size.width / 2 - position - 85,
                child: Transform.scale(
                  scale: _controller.value <= 0.5 ? 0.9 : 0.8,
                  child: SmallHeroCard(
                    hero: widget.secondCard.hero,
                    isSelected: _isSecondCardSelected, // Initially false, updated after animation
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}