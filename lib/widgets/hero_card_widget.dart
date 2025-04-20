import 'package:flutter/material.dart';
import 'package:heroes_apir/models/HeroModel.dart';

class HeroCardWidget extends StatelessWidget {
  final HeroModel hero;
  // final String heroName;
  // final String imageUrl;
  // final Map<String, int> powerstats;
  final String imageProxyUrl = "http://localhost:3000/proxy-image?url=";

  const HeroCardWidget({
    Key? key,
    required this.hero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Hero Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageProxyUrl + hero.imageUrl,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    width: 150,
                    color: Colors.blueGrey,
                    child: Icon(Icons.broken_image, color: Colors.white),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Hero Name
            Text(
              hero.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 8),
            // Powerstats
            ...hero.powerStats.toMap().entries.map((entry) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  entry.value.toString(),
                  style: TextStyle(
                    color: Colors.blue.shade600,
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
