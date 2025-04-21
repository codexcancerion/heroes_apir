import 'package:flutter/material.dart';

class PowerStatsWidget extends StatefulWidget {
  final Map<String, int> powerStats;

  const PowerStatsWidget({Key? key, required this.powerStats})
    : super(key: key);

  @override
  _PowerStatsWidgetState createState() => _PowerStatsWidgetState();
}

class _PowerStatsWidgetState extends State<PowerStatsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flameController;

  @override
  void initState() {
    super.initState();
    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true); // Repeat the animation back and forth
  }

  @override
  void dispose() {
    _flameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          widget.powerStats.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _getPowerStatIcon(entry.key, entry.value),
                      const SizedBox(width: 8),
                      Text(
                        entry.key.toUpperCase(),
                        style: TextStyle(
                          color:
                              entry.value >= 70
                                  ? Colors.blue.shade700
                                  : Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  entry.value >= 90
                      ? Row(
                        children: [
                          AnimatedBuilder(
                            animation: _flameController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1 + (_flameController.value * 0.2),
                                child: const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          Text(
                            entry.value.toString(),
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                      : Text(
                        entry.value.toString(),
                        style: TextStyle(
                          color:
                              entry.value >= 70
                                  ? Colors.blue.shade700
                                  : Colors.black54,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Icon _getPowerStatIcon(String statName, int value) {
    switch (statName.toLowerCase()) {
      case 'intelligence':
        return Icon(
          Icons.psychology,
          color: value >= 70 ? Colors.blue.shade700 : Colors.black54,
          size: 18,
        );
      case 'strength':
        return Icon(
          Icons.fitness_center,
          color: value >= 70 ? Colors.blue.shade700 : Colors.black54,
          size: 18,
        );
      case 'speed':
        return Icon(
          Icons.speed,
          color: value >= 70 ? Colors.blue.shade700 : Colors.black54,
          size: 18,
        );
      case 'durability':
        return Icon(
          Icons.shield,
          color: value >= 70 ? Colors.blue.shade700 : Colors.black54,
          size: 18,
        );
      case 'power':
        return Icon(
          Icons.flash_on,
          color: value >= 70 ? Colors.blue.shade700 : Colors.black54,
          size: 18,
        );
      case 'combat':
        return Icon(
          Icons.sports_martial_arts,
          color: value >= 70 ? Colors.blue.shade700 : Colors.black54,
          size: 18,
        );
      default:
        return const Icon(Icons.help_outline, color: Colors.grey, size: 18);
    }
  }
}
