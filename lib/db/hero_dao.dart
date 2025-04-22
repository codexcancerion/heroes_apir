import 'package:heroes_apir/db/database_manager.dart';
import 'package:heroes_apir/models/HeroModel.dart';
import 'package:heroes_apir/models/PowerStats.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class HeroDao {
  final DatabaseManager _dbManager = DatabaseManager.instance;

  Future<Database> get database async => await _dbManager.database;

  Future<void> saveHero(HeroModel hero) async {
    final db = await database;

    // Insert into heroes table
    await db.insert('heroes', {
      'id': hero.id,
      'name': hero.name,
      'imageUrl': hero.imageUrl,
    });

    // Insert into powerstats table
    await db.insert('powerstats', {
      'heroId': hero.id,
      'intelligence': hero.powerStats.intelligence,
      'strength': hero.powerStats.strength,
      'speed': hero.powerStats.speed,
      'durability': hero.powerStats.durability,
      'power': hero.powerStats.power,
      'combat': hero.powerStats.combat,
    });

    // Insert into biography table
    await db.insert('biography', {
      'heroId': hero.id,
      'fullName': hero.biography.fullName,
      'alterEgos': hero.biography.alterEgos,
      'aliases': hero.biography.aliases.join(','),
      'placeOfBirth': hero.biography.placeOfBirth,
      'firstAppearance': hero.biography.firstAppearance,
      'publisher': hero.biography.publisher,
      'alignment': hero.biography.alignment,
    });

    // Insert into appearance table
    await db.insert('appearance', {
      'heroId': hero.id,
      'gender': hero.appearance.gender,
      'race': hero.appearance.race,
      'height': hero.appearance.height.join(','),
      'weight': hero.appearance.weight.join(','),
      'eyeColor': hero.appearance.eyeColor,
      'hairColor': hero.appearance.hairColor,
    });

    // Insert into work table
    await db.insert('work', {
      'heroId': hero.id,
      'occupation': hero.work.occupation,
      'base': hero.work.base,
    });

    // Insert into connections table
    await db.insert('connections', {
      'heroId': hero.id,
      'groupAffiliation': hero.connections.groupAffiliation,
      'relatives': hero.connections.relatives,
    });
  }


  Future<HeroModel?> getHeroById(int id) async {
    final db = await database;

    // Fetch hero data from the heroes table
    final heroData = await db.query('heroes', where: 'id = ?', whereArgs: [id]);

    if (heroData.isEmpty) return null; // Return null if no hero is found

    // Fetch related data from other tables
    final powerStatsData = await db.query(
      'powerstats',
      where: 'heroId = ?',
      whereArgs: [id],
    );

    final biographyData = await db.query(
      'biography',
      where: 'heroId = ?',
      whereArgs: [id],
    );

    final appearanceData = await db.query(
      'appearance',
      where: 'heroId = ?',
      whereArgs: [id],
    );

    final workData = await db.query(
      'work',
      where: 'heroId = ?',
      whereArgs: [id],
    );

    final connectionsData = await db.query(
      'connections',
      where: 'heroId = ?',
      whereArgs: [id],
    );

    // Construct and return a HeroModel object
    return HeroModel(
      id: heroData.first['id'] as int,
      name: heroData.first['name'] as String,
      imageUrl: heroData.first['imageUrl'] as String,
      powerStats: PowerStats(
        intelligence: powerStatsData.first['intelligence'] as int,
        strength: powerStatsData.first['strength'] as int,
        speed: powerStatsData.first['speed'] as int,
        durability: powerStatsData.first['durability'] as int,
        power: powerStatsData.first['power'] as int,
        combat: powerStatsData.first['combat'] as int,
      ),
      biography: Biography(
        fullName: biographyData.first['fullName'] as String,
        alterEgos: biographyData.first['alterEgos'] as String,
        aliases: (biographyData.first['aliases'] as String).split(','),
        placeOfBirth: biographyData.first['placeOfBirth'] as String,
        firstAppearance: biographyData.first['firstAppearance'] as String,
        publisher: biographyData.first['publisher'] as String,
        alignment: biographyData.first['alignment'] as String,
      ),
      appearance: Appearance(
        gender: appearanceData.first['gender'] as String,
        race: appearanceData.first['race'] as String,
        height: (appearanceData.first['height'] as String).split(','),
        weight: (appearanceData.first['weight'] as String).split(','),
        eyeColor: appearanceData.first['eyeColor'] as String,
        hairColor: appearanceData.first['hairColor'] as String,
      ),
      work: Work(
        occupation: workData.first['occupation'] as String,
        base: workData.first['base'] as String,
      ),
      connections: Connections(
        groupAffiliation: connectionsData.first['groupAffiliation'] as String,
        relatives: connectionsData.first['relatives'] as String,
      ),
    );
  }

  
  // New method to fetch all heroes
  Future<List<HeroModel>> getAllHeroes() async {
    final db = await database;

    // Fetch all heroes from the heroes table
    final heroesData = await db.query('heroes');

    // If no heroes are found, return an empty list
    if (heroesData.isEmpty) return [];

    // Fetch related data for each hero and construct HeroModel objects
    List<HeroModel> heroes = [];
    for (var hero in heroesData) {
      final id = hero['id'] as int;
      final heroModel = await getHeroById(id);
      if (heroModel != null) {
        heroes.add(heroModel);
      }
    }

    return heroes;
  }


}
