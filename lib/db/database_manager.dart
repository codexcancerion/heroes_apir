import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();
  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('heroes_apir.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    databaseFactory = databaseFactoryFfi;

    // Get the path to the device's database directory
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    // Check if the database already exists
    final exists = await databaseExists(path);

    if (!exists) {
      // If the database does not exist, copy it from assets
      print('Copying pre-populated database from assets...');
      try {
        final data = await rootBundle.load('assets/database/$fileName');
        final bytes = data.buffer.asUint8List();
        await File(path).writeAsBytes(bytes, flush: true);
        print('Database copied successfully.');
      } catch (e) {
        print('Error copying database: $e');
        throw Exception('Failed to copy database from assets.');
      }
    } else {
      print('Database already exists on the device.');
    }

    // Open the database
    return await openDatabase(path);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}