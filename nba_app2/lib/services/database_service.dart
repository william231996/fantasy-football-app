import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/sleeper_player.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  static Database? _db;

  // ensure there is only a single instance of the data service class in the lifecycle of the app
  static final DatabaseService instance = DatabaseService._constructor();

  final String _playersTableName = "players";

  final String _playerIdColumnName = "player_id";
  final String _playerFirstNameColumnName = "first_name";
  final String _playerLastNameColumnName = "last_name";
  final String _playerTeamColumnName = "team";
  final String _playerNumberColumnName = "number";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  // creating a function that sets up the database when the service is created
  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "players_db.db");

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_playersTableName (
          $_playerIdColumnName TEXT PRIMARY KEY,
          $_playerFirstNameColumnName TEXT,
          $_playerLastNameColumnName TEXT,
          $_playerTeamColumnName TEXT,
          $_playerNumberColumnName INTEGER
        )
        ''');
      },
    );
    return database;
  }

  Future<void> insertPlayers(List<SleeperPlayer> players) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        for (var player in players) {
          await txn.insert(
            _playersTableName,
            player.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      print('An error occurred while inserting players: $e');
    }
  }

  Future<SleeperPlayer?> getPlayerById(String playerId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _playersTableName,
      where: '$_playerIdColumnName = ?',
      whereArgs: [playerId],
    );
    if (maps.isNotEmpty) {
      return SleeperPlayer.fromJson(maps.first);
    } else {
      return null;
    }
  }

}