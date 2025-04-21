import 'package:flutter/material.dart';
import 'package:heroes_apir/db/database.dart';
import 'package:heroes_apir/models/HeroModel.dart';

class HeroCardWidget extends StatefulWidget {
  final HeroModel hero;
  final String imageProxyUrl = "http://localhost:3000/proxy-image?url=";

  const HeroCardWidget({Key? key, required this.hero}) : super(key: key);

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
      // Remove bookmark
      await DatabaseManager.instance.deleteBookmark(widget.hero.id);
    } else {
      // Add bookmark
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
          maxWidth: 400, // Set a max width for responsiveness
        ),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hero Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.imageProxyUrl + widget.hero.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.blueGrey.shade200,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Hero Name
                Text(
                  widget.hero.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Divider
                Divider(
                  color: Colors.blue.shade300,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 12),
                // Powerstats Section
                Column(
                  children: widget.hero.powerStats.toMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key.toUpperCase(),
                            style: TextStyle(
                              color: entry.value > 70
                                  ? Colors.blue.shade700
                                  : Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            entry.value.toString(),
                            style: TextStyle(
                              color: entry.value > 70
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
                ),
                const SizedBox(height: 16),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Bookmark Button
                    ElevatedButton.icon(
                      onPressed: _toggleBookmark,
                      icon: Icon(
                        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: _isBookmarked ? Colors.white : Colors.black54,
                      ),
                      label: Text(
                        'Bookmark',
                        style: TextStyle(
                          color: _isBookmarked ? Colors.white : Colors.black54,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isBookmarked ? Colors.blue.shade700 : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // View Info Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // View Info functionality to be added later
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
