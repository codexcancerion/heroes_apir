import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package

class DiceWidget extends StatefulWidget {
  final int diceNumber; // Dynamic dice number passed as a parameter
  final VoidCallback onProceed; // Callback function for the "Proceed" button

  const DiceWidget({super.key, required this.diceNumber, required this.onProceed});

  @override
  _DiceWidgetState createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fallAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _shuffleAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize the audio player

  bool _showCards = false; // Flag to control when to start showing the cards
  int _visibleCards = 0; // Number of cards currently visible
  bool _showProceedButton = false; // Flag to control when to show the "Proceed" button

  // Unicode dice characters for numbers 1 to 6
  final List<String> _diceFaces = ['🎲', '⚀', '⚁', '⚂', '⚃', '⚄', '⚅'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Total animation duration
    );

    // Falling effect (moves down)
    _fallAnimation = Tween<double>(begin: -500, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.2, curve: Curves.easeIn)),
    );

    // Bouncing effect (bounces more significantly after falling)
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6, curve: Curves.elasticOut)),
    );

    // Shuffling effect (rotates and scales)
    _shuffleAnimation = Tween<double>(begin: 0.0, end: 6 * pi).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0, curve: Curves.easeInOut)),
    );

    // Add a listener to play the sound when the shuffle animation starts
    _controller.addListener(() {
      if (_controller.value >= 0.6 && _controller.value < 0.61) {
        _playShuffleSound(); // Play the dice sound
      }
    });

    // Listen for animation completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showCards = true; // Start showing the cards after the dice animation is done
        });
        _revealCards(); // Start revealing the cards one by one
      }
    });

    _controller.forward(); // Start the animation initially
  }

  Future<void> _playShuffleSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/dice.mp3')); // Ensure the file exists in assets
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _revealCards() async {
    for (int i = 1; i <= widget.diceNumber && i <= 6; i++) {
      await Future.delayed(const Duration(milliseconds: 300)); // Delay between each card reveal
      setState(() {
        _visibleCards = i; // Increment the number of visible cards
      });
    }
    if (widget.diceNumber > 6) {
      // Delay for the "+X" card
      await Future.delayed(const Duration(milliseconds: 300));
    }
    setState(() {
      _showProceedButton = true; // Show the "Proceed" button after all cards are revealed
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose(); // Dispose of the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated Dice
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _fallAnimation.value), // Falling effect
              child: Transform.scale(
                scale: _bounceAnimation.value, // Bouncing effect
                child: Transform.rotate(
                  angle: _shuffleAnimation.value, // Shuffling effect
                  child: child,
                ),
              ),
            );
          },
          child: Text(
            _diceFaces[widget.diceNumber], // Display dice face based on the passed number
            style: const TextStyle(
              fontSize: 100, // Large font size for dice
              color: Colors.white, // Set the dice color to white
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Stacked Card UI (only shown after animation is complete)
        if (_showCards)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80, // Fixed height for the stacked cards
                width: 150, // Width to fit the stack
                child: Stack(
                  children: List.generate(
                    _visibleCards, // Show only the visible cards
                    (index) {
                      return Positioned(
                        left: index * 10.0, // Offset each card slightly
                        child: Container(
                          width: 40,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue.shade800),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  )
                    // Add a "+X" container if there are more than 6 cards
                    ..addAll(
                      _visibleCards == 6 && widget.diceNumber > 6
                          ? [
                              Positioned(
                                left: 6 * 10.0, // Position the "+X" container
                                child: Container(
                                  width: 40,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue.shade800),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+${widget.diceNumber - 6}', // Remaining card count
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          : [],
                    ),
                ),
              ),
              const SizedBox(width: 16), // Space between stack and count
              // Card Count
              if (_visibleCards > 0)
                Column(
                  children: [
                    const Text(
                      'Winner takes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${widget.diceNumber} Cards',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        const SizedBox(height: 16),
        // Proceed Button
        if (_showProceedButton)
          ElevatedButton(
            onPressed: widget.onProceed, // Call the callback function
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Proceed'), // Button text
          ),
      ],
    );
  }
}