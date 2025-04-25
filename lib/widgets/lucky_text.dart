import 'package:flutter/material.dart';

class LuckyText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  const LuckyText({
    super.key,
    required this.text,
    this.fontSize = 24.0, // Default font size
    this.color = Colors.black87, // Default color
    this.fontWeight = FontWeight.normal, // Default weight
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        // fontFamily: 'LuckiestGuy', // Use the LuckiestGuy font
        fontFamily: 'Marcellus', // Use the LuckiestGuy font
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}