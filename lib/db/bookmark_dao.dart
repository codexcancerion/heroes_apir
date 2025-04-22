import 'package:heroes_apir/db/database_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BookmarkDao {
  final DatabaseManager _dbManager = DatabaseManager.instance;

  Future<void> saveBookmark(int heroId) async {
    final db = await _dbManager.database;
    await db.insert(
      'bookmark',
      {'heroId': heroId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<int>> getBookmarks() async {
    final db = await _dbManager.database;
    final result = await db.query('bookmark');
    return result.map((e) => e['heroId'] as int).toList();
  }

  Future<void> deleteBookmark(int heroId) async {
    final db = await _dbManager.database;
    await db.delete(
      'bookmark',
      where: 'heroId = ?',
      whereArgs: [heroId],
    );
  }

  Future<bool> isBookmarked(int heroId) async {
    final db = await _dbManager.database;
    final result = await db.query(
      'bookmark',
      where: 'heroId = ?',
      whereArgs: [heroId],
    );
    return result.isNotEmpty;
  }
}