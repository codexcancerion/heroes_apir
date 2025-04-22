import 'dart:convert';
import 'package:heroes_apir/db/api_access_token_dao.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:http/http.dart' as http;

class SuperheroApi {
  final String proxyUrl = 'https://superheroes-proxy.vercel.app/api';
  final ApiAccessTokenDao _apiAccessTokenDao = ApiAccessTokenDao();

  // Method to fetch superhero data by ID
  Future<List<HeroModel>> fetchHeroById(String characterId) async {
    try {
      // Fetch the access token from the database
      final token = await _apiAccessTokenDao.getApiAccessToken();

      if (token == null) {
        throw Exception('Access token not found.');
      }

      final url = Uri.parse('$proxyUrl/$token/$characterId');
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
      // Fetch the access token from the database
      final token = await _apiAccessTokenDao.getApiAccessToken();

      if (token == null) {
        throw Exception('Access token not found.');
      }

      final url = Uri.parse('$proxyUrl/$token/range/$startId/$endId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        for (var hero in json.decode(response.body)) {
          heroes.add(HeroModel.fromJson(hero));
        }
      } else {
        throw Exception(
          'Failed to load superheroes: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching superheroes: $e');
    }

    return heroes;
  }

  // Method to search for a superhero by name
  Future<List<HeroModel>> searchHeroByName(String name) async {
    try {
      // Fetch the access token from the database
      final token = await _apiAccessTokenDao.getApiAccessToken();

      if (token == null) {
        throw Exception('Access token not found.');
      }

      final url = Uri.parse('$proxyUrl/$token/search/$name');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['response'] == 'success') {
          List<HeroModel> heroes = [];
          for (var hero in data['results']) {
            heroes.add(HeroModel.fromJson(hero));
          }
          return heroes;
        } else {
          throw Exception('No heroes found with the name: $name');
        }
      } else {
        throw Exception(
          'Failed to search for superhero: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error searching for superhero: $e');
    }
  }

  // Method to test the access token
  Future<void> testAccessToken(String accessToken) async {
    final url = Uri.parse('$proxyUrl/test?token=$accessToken'); // Updated to use query parameter

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Token is valid
          return;
        } else {
          throw Exception(data['message'] ?? 'Token is invalid.');
        }
      } else {
        throw Exception(
          'Failed to validate access token: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error validating access token: $e');
    }
  }
}
