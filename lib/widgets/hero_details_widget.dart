import 'package:flutter/material.dart';
import 'package:heroes_apir/db/database.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/widgets/powerstats_widget.dart';

class HeroDetailsWidget extends StatefulWidget {
  final HeroModel hero;

  const HeroDetailsWidget({Key? key, required this.hero}) : super(key: key);

  @override
  _HeroDetailsWidgetState createState() => _HeroDetailsWidgetState();
}

class _HeroDetailsWidgetState extends State<HeroDetailsWidget> {
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.hero.imageUrl,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: 200,
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
              ),
              const SizedBox(height: 16),
              // Hero Name and Bookmark Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // put gap between name and bookmark button
                
                children: [
                  Text(
                      widget.hero.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  IconButton(
                    onPressed: _toggleBookmark,
                    icon: Icon(
                      _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: _isBookmarked ? Colors.blue : Colors.black54,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Powerstats Section
              _buildSectionTitle('Power Stats'),
              const SizedBox(height: 8),
              PowerStatsWidget(powerStats: widget.hero.powerStats.toMap()),
              const SizedBox(height: 16),
              // Biography Section
              _buildSectionTitle('Biography'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.person, 'Full Name', widget.hero.biography.fullName),
              _buildDivider(),
              _buildDetailRow(Icons.person_outline, 'Alter Egos', widget.hero.biography.alterEgos),
              _buildDivider(),
              _buildDetailRow(Icons.group, 'Aliases', widget.hero.biography.aliases.join(', ')),
              _buildDivider(),
              _buildDetailRow(Icons.location_city, 'Place of Birth', widget.hero.biography.placeOfBirth),
              _buildDivider(),
              _buildDetailRow(Icons.book, 'First Appearance', widget.hero.biography.firstAppearance),
              _buildDivider(),
              _buildDetailRow(Icons.publish, 'Publisher', widget.hero.biography.publisher),
              _buildDivider(),
              _buildDetailRow(Icons.balance, 'Alignment', widget.hero.biography.alignment),
              const SizedBox(height: 16),
              // Appearance Section
              _buildSectionTitle('Appearance'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.male, 'Gender', widget.hero.appearance.gender),
              _buildDivider(),
              _buildDetailRow(Icons.palette, 'Race', widget.hero.appearance.race),
              _buildDivider(),
              _buildDetailRow(Icons.height, 'Height', widget.hero.appearance.height.join(', ')),
              _buildDivider(),
              _buildDetailRow(Icons.line_weight, 'Weight', widget.hero.appearance.weight.join(', ')),
              _buildDivider(),
              _buildDetailRow(Icons.remove_red_eye, 'Eye Color', widget.hero.appearance.eyeColor),
              _buildDivider(),
              _buildDetailRow(Icons.face, 'Hair Color', widget.hero.appearance.hairColor),
              const SizedBox(height: 16),
              // Work Section
              _buildSectionTitle('Work'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.work, 'Occupation', widget.hero.work.occupation),
              _buildDivider(),
              _buildDetailRow(Icons.home, 'Base', widget.hero.work.base),
              const SizedBox(height: 16),
              // Connections Section
              _buildSectionTitle('Connections'),
              const SizedBox(height: 8),
              _buildDetailRow(Icons.groups, 'Group Affiliation', widget.hero.connections.groupAffiliation),
              _buildDivider(),
              _buildDetailRow(Icons.family_restroom, 'Relatives', widget.hero.connections.relatives),
              const SizedBox(height: 80), // Add bottom padding to avoid overlap with the floating button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.normal,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 0.5,
      height: 16,
    );
  }
}