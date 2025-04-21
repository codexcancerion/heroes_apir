import 'package:flutter/material.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/screens/hero_full_information.dart';
import 'package:heroes_apir/widgets/powerstats_widget.dart';

class SmallHeroCard extends StatefulWidget {
  final HeroModel hero;
  final String imageProxyUrl;

  const SmallHeroCard({
    Key? key,
    required this.hero,
    this.imageProxyUrl = "http://localhost:3000/proxy-image?url=",
  }) : super(key: key);

  @override
  _SmallHeroCardState createState() => _SmallHeroCardState();
}

class _SmallHeroCardState extends State<SmallHeroCard> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    // Simulate checking bookmark status
    // Replace with actual database logic
    setState(() {
      _isBookmarked = false; // Default to not bookmarked
    });
  }

  Future<void> _toggleBookmark() async {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    // Add logic to save or remove bookmark in the database
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image and Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imageProxyUrl + widget.hero.imageUrl,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        width: 80,
                        color: Colors.blueGrey.shade200,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Hero Name and Buttons
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hero.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _toggleBookmark,
                            icon: Icon(
                              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: _isBookmarked ? Colors.blue : Colors.black54,
                              size: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HeroFullInformation(hero: widget.hero),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Power Stats
            PowerStatsWidget(powerStats: widget.hero.powerStats.toMap()),
          ],
        ),
      ),
    );
  }
}