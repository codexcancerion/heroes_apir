import 'dart:convert';
import 'package:heroes_apir/db/database.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:http/http.dart' as http;

class SuperheroApi {
  final String proxyUrl = 'http://localhost:3000/api';
  // final String accessToken = 'eae25af25d8ef0fbf045fd97217bd209';

  // create a function to fetch accessToken from the apiAccessToken from the database
  final Future<String?> accessToken =
      DatabaseManager.instance.getApiAccessToken();

  Future<List<HeroModel>> testAccessToken(
    String accessToken,
  ) async {
    final url = Uri.parse('$proxyUrl/$accessToken/1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<HeroModel> heroes = [
          HeroModel.fromJson(json.decode(response.body)),
        ];
        return heroes;
      } else {
        throw Exception(
          'Failed to load superhero data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching superhero data: $e');
    }
  }

  // Method to fetch superhero data by ID
  Future<List<HeroModel>> fetchHeroById(
    String characterId,
  ) async {
    final url = Uri.parse('$proxyUrl/$accessToken/$characterId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<HeroModel> heroes = [
          HeroModel.fromJson(json.decode(response.body)),
        ];
        return heroes;
      } else {
        throw Exception(
          'Failed to load superhero data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching superhero data: $e');
    }
  }

  // Method to fetch all superheroes by iterating over a range of IDs
  Future<List<HeroModel>> fetchAllHeroes({
    int startId = 1,
    int endId = 10,
  }) async {
    List<HeroModel> heroes = [];

    try {
      final url = Uri.parse('$proxyUrl/$accessToken/range/$startId/$endId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        for (var hero in json.decode(response.body)) {
          heroes.add(HeroModel.fromJson(hero));
        }
      } else {
        print('Failed to load superheroes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching superheroes: $e');
    }

    return heroes;
  }
}
