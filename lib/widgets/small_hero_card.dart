import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart'; // Import the marquee package
import 'package:heroes_apir/db/bookmark_dao.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/screens/hero_full_information.dart';
import 'package:heroes_apir/widgets/powerstats_widget.dart';

class SmallHeroCard extends StatefulWidget {
  final HeroModel hero;
  final String imageProxyUrl;
  final bool isSelected; // Parameter to indicate selection

  const SmallHeroCard({
    super.key,
    required this.hero,
    this.imageProxyUrl = "https://superheroes-proxy.vercel.app/api/proxy-image?url=",
    this.isSelected = true, // Default value is false
  });

  @override
  _SmallHeroCardState createState() => _SmallHeroCardState();
}

class _SmallHeroCardState extends State<SmallHeroCard> {
  bool _isBookmarked = false;
  final BookmarkDao _bookmarkDao = BookmarkDao();

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    final isBookmarked = await _bookmarkDao.isBookmarked(widget.hero.id);
    if (mounted) {
      setState(() {
        _isBookmarked = isBookmarked;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      await _bookmarkDao.deleteBookmark(widget.hero.id);
    } else {
      await _bookmarkDao.saveBookmark(widget.hero.id);
    }
    if (mounted) {
      setState(() {
        _isBookmarked = !_isBookmarked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 200,
          maxHeight: 316,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Smooth transition
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: widget.isSelected
                ? const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: .5,
                    ),
                  ]
                : [],
          ),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: widget.isSelected
                ? const EdgeInsets.all(3) // Add space for gradient border
                : EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
                            SizedBox(
                              height: 24, // Fixed height for the marquee
                              child: widget.hero.name.length > 8
                                  ? Marquee(
                                      text: widget.hero.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      scrollAxis: Axis.horizontal,
                                      blankSpace: 20.0,
                                      velocity: 30.0,
                                      pauseAfterRound: const Duration(seconds: 1),
                                      startPadding: 10.0,
                                      accelerationDuration:
                                          const Duration(seconds: 1),
                                      accelerationCurve: Curves.easeIn,
                                      decelerationDuration:
                                          const Duration(milliseconds: 500),
                                      decelerationCurve: Curves.easeOut,
                                    )
                                  : Text(
                                      widget.hero.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Power Stats Section
                  PowerStatsWidget(powerStats: widget.hero.powerStats.toMap()),
                  const SizedBox(height: 8),
                  // View Info Button
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HeroFullInformation(hero: widget.hero),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.black54,
                          ),
                        ),
                        IconButton(
                          onPressed: _toggleBookmark,
                          icon: Icon(
                            _isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: _isBookmarked ? Colors.blue : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
