import 'package:heroes_apir/db/database_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ApiAccessTokenDao {
  final DatabaseManager _dbManager = DatabaseManager.instance;

  Future<void> saveApiAccessToken(String token) async {
    final db = await _dbManager.database;
    await db.insert(
      'apiAccessToken',
      {'token': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getApiAccessToken() async {
    final db = await _dbManager.database;
    final result = await db.query('apiAccessToken', limit: 1);
    if (result.isNotEmpty) {
     return result.first['token'] as String?;
    }
    return null;
    // return "eae25af25d8ef0fbf045fd97217bd209";
  }

  Future<void> deleteApiAccessToken() async {
    final db = await _dbManager.database;
    await db.delete('apiAccessToken');
  }
}
