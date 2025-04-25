import 'package:flutter/material.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/screens/mainmenu.dart';
import 'package:heroes_apir/utils/api.dart';
import 'package:heroes_apir/widgets/hero_card_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final SuperheroApi _api = SuperheroApi();
  List<HeroModel> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _searchHero() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a hero name to search.';
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _api.searchHeroByName(query);
      setState(() {
        _searchResults = results;
        if (_searchResults.isEmpty) {
          _errorMessage = 'No heroes found with the name "$query".';
        }
      });
    } on Exception catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while searching: ${e.toString()}';
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Heroes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Enter hero name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Centered Search Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _searchHero,
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text(
                  'Search',
                  style: TextStyle(color: Colors.white), // Explicitly set text color to white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Loading Indicator
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            // Error Message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: _searchResults.isEmpty ? Colors.black54 : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            // Search Results
            if (!_isLoading && _searchResults.isEmpty && _errorMessage == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'No results yet. Start searching for your favorite heroes!',
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: HeroCardWidget(hero: _searchResults[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: MainMenu(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}