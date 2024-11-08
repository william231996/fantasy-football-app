import 'dart:convert';

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
  final String _playerPositionColumnName = "position";
  final String _playerHeightColumnName = "height";
  final String _playerWeightColumnName = "weight";
  final String _playerAgeColumnName = "age";

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
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_playersTableName (
          $_playerIdColumnName INTEGER PRIMARY KEY,
          $_playerFirstNameColumnName TEXT,
          $_playerLastNameColumnName TEXT,
          $_playerTeamColumnName TEXT,
          $_playerNumberColumnName INTEGER,
          $_playerPositionColumnName TEXT,
          $_playerHeightColumnName TEXT,
          $_playerWeightColumnName INTEGER,
          $_playerAgeColumnName INTEGER
        )
        ''');
      },
    );
    return database;
  }

  Future getPlayers() async {
    final response = await http.get(
      Uri.https('api.sleeper.app', '/v1/players/nba'),
    );
    var jsonData = jsonDecode(response.body);
    for (var eachPlayer in jsonData) {}
  }

    void addPlayer(SleeperPlayer player) async {
    final db = await database;
    await db.insert(
      _playersTableName,
      {
        _playerIdColumnName: player.player_id,
        _playerFirstNameColumnName: player.first_name,
        _playerLastNameColumnName: player.last_name,
        _playerTeamColumnName: player.team,
        _playerNumberColumnName: player.number,
        _playerPositionColumnName: player.position,
        _playerHeightColumnName: player.height,
        _playerWeightColumnName: player.weight,
        _playerAgeColumnName: player.age,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
