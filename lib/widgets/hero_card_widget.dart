import 'package:flutter/material.dart';
import 'package:heroes_apir/db/database.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/screens/hero_full_information.dart';
import 'package:heroes_apir/widgets/powerstats_widget.dart';

class HeroCardWidget extends StatefulWidget {
  final HeroModel hero;
  final String imageProxyUrl;

  const HeroCardWidget({
    Key? key,
    required this.hero,
    this.imageProxyUrl = "http://localhost:3000/proxy-image?url=",
  }) : super(key: key);

  @override
  _HeroCardWidgetState createState() => _HeroCardWidgetState();
}

class _HeroCardWidgetState extends State<HeroCardWidget> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    final isBookmarked = await DatabaseManager.instance.isBookmarked(widget.hero.id);
    setState(() {
      _isBookmarked = isBookmarked;
    });
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      await DatabaseManager.instance.deleteBookmark(widget.hero.id);
    } else {
      await DatabaseManager.instance.saveBookmark(widget.hero.id);
    }
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400, // Set the maximum width for the card
        ),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image and Name in a Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Hero Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.imageProxyUrl + widget.hero.imageUrl,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 60,
                            width: 60,
                            color: Colors.blueGrey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Hero Name and Full Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.hero.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontFamily: 'Marcellus',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.hero.biography.fullName.isNotEmpty
                                ? widget.hero.biography.fullName
                                : 'No name',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Bookmark Button
                    IconButton(
                      onPressed: _toggleBookmark,
                      icon: Icon(
                        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: _isBookmarked ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Power Stats Section
                PowerStatsWidget(powerStats: widget.hero.powerStats.toMap()),
                const SizedBox(height: 8),
                // View Info Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HeroFullInformation(hero: widget.hero),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('View Info'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}