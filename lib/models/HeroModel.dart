import 'package:heroes_apir/models/PowerStats.dart';

class HeroModel {
  final int id;
  final String name;
  final String imageUrl;
  final PowerStats powerStats;
  final Biography biography;
  final Appearance appearance;
  final Work work;
  final Connections connections;

  HeroModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.powerStats,
    required this.biography,
    required this.appearance,
    required this.work,
    required this.connections,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: int.parse(json['id']),
      name: json['name'],
      imageUrl: json['image']['url'],
      powerStats: PowerStats.fromJson(json['powerstats']),
      biography: Biography.fromJson(json['biography']),
      appearance: Appearance.fromJson(json['appearance']),
      work: Work.fromJson(json['work']),
      connections: Connections.fromJson(json['connections']),
    );
  }
}


class Biography {
  final String fullName;
  final String alterEgos;
  final List<String> aliases;
  final String placeOfBirth;
  final String firstAppearance;
  final String publisher;
  final String alignment;

  Biography({
    required this.fullName,
    required this.alterEgos,
    required this.aliases,
    required this.placeOfBirth,
    required this.firstAppearance,
    required this.publisher,
    required this.alignment,
  });

  factory Biography.fromJson(Map<String, dynamic> json) {
    return Biography(
      fullName: json['full-name'] ?? '',
      alterEgos: json['alter-egos'] ?? '',
      aliases: List<String>.from(json['aliases'] ?? []),
      placeOfBirth: json['place-of-birth'] ?? '',
      firstAppearance: json['first-appearance'] ?? '',
      publisher: json['publisher'] ?? '',
      alignment: json['alignment'] ?? '',
    );
  }
}

class Appearance {
  final String gender;
  final String race;
  final List<String> height;
  final List<String> weight;
  final String eyeColor;
  final String hairColor;

  Appearance({
    required this.gender,
    required this.race,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hairColor,
  });

  factory Appearance.fromJson(Map<String, dynamic> json) {
    return Appearance(
      gender: json['gender'] ?? '',
      race: json['race'] ?? '',
      height: List<String>.from(json['height'] ?? []),
      weight: List<String>.from(json['weight'] ?? []),
      eyeColor: json['eye-color'] ?? '',
      hairColor: json['hair-color'] ?? '',
    );
  }
}

class Work {
  final String occupation;
  final String base;

  Work({
    required this.occupation,
    required this.base,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      occupation: json['occupation'] ?? '',
      base: json['base'] ?? '',
    );
  }
}

class Connections {
  final String groupAffiliation;
  final String relatives;

  Connections({
    required this.groupAffiliation,
    required this.relatives,
  });

  factory Connections.fromJson(Map<String, dynamic> json) {
    return Connections(
      groupAffiliation: json['group-affiliation'] ?? '',
      relatives: json['relatives'] ?? '',
    );
  }
}

