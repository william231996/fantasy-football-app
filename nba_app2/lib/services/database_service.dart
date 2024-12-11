import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/bdl_player.dart';
import 'package:nba_app2/models/season_averages.dart';
import 'package:nba_app2/models/sleeper_player.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  static Database? _db;

  // ensure there is only a single instance of the data service class in the lifecycle of the app
  static final DatabaseService instance = DatabaseService._constructor();

  // sleepers players (keep as is)
  final String _playersTableName = "players";
  final String _playerIdColumnName = "player_id";
  final String _playerFirstNameColumnName = "first_name";
  final String _playerLastNameColumnName = "last_name";
  final String _playerTeamColumnName = "team";
  final String _playerNumberColumnName = "number";
  final String _playerBdlIdColumnName = "bdl_player_id"; // New column

  // balldontlie active players (reuse this table for league leader players)
  final String _activePlayersTableName = "active_players";
  final String _activePlayerIdColumnName = "id";
  final String _activePlayerFirstNameColumnName = "first_name";
  final String _activePlayerLastNameColumnName = "last_name";
  final String _activePlayerHeightColumnName = "height";
  final String _activePlayerWeightColumnName = "weight";
  final String _activePlayerPositionColumnName = "position";
  final String _activePlayerJerseyNumberColumnName = "jersey_number";
  final String _activePlayerCollegeColumnName = "college";
  final String _activePlayerCountryColumnName = "country";

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
      version: 5, // Increment version if you haven't done so before
      onCreate: (db, version) {
        // Create the sleepers players table
        db.execute('''
          CREATE TABLE $_playersTableName (
            $_playerIdColumnName TEXT PRIMARY KEY,
            $_playerFirstNameColumnName TEXT,
            $_playerLastNameColumnName TEXT,
            $_playerTeamColumnName TEXT,
            $_playerNumberColumnName INTEGER,
            $_playerBdlIdColumnName INTEGER 
          )
        ''');

        // Create the active_players table for balldontlie players
        db.execute('''
          CREATE TABLE $_activePlayersTableName (
            $_activePlayerIdColumnName INTEGER PRIMARY KEY,
            $_activePlayerFirstNameColumnName TEXT,
            $_activePlayerLastNameColumnName TEXT,
            $_activePlayerHeightColumnName TEXT,
            $_activePlayerWeightColumnName TEXT,
            $_activePlayerPositionColumnName TEXT,
            $_activePlayerJerseyNumberColumnName TEXT,
            $_activePlayerCollegeColumnName TEXT,
            $_activePlayerCountryColumnName TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // If active_players wasn't previously created, create it now.
          await db.execute('''
            CREATE TABLE $_activePlayersTableName (
              $_activePlayerIdColumnName INTEGER PRIMARY KEY,
              $_activePlayerFirstNameColumnName TEXT,
              $_activePlayerLastNameColumnName TEXT,
              $_activePlayerHeightColumnName TEXT,
              $_activePlayerWeightColumnName TEXT,
              $_activePlayerPositionColumnName TEXT,
              $_activePlayerJerseyNumberColumnName TEXT,
              $_activePlayerCollegeColumnName TEXT,
              $_activePlayerCountryColumnName TEXT
            )
          ''');
        }

        // If we didn't have bdl_player_id before, add it when upgrading
        if (oldVersion < 5) {
          // Add bdl_player_id column to players table if it doesn't exist
          try {
            await db.execute('''
              ALTER TABLE $_playersTableName ADD COLUMN $_playerBdlIdColumnName INTEGER
            ''');
          } catch (e) {
            print('Column $_playerBdlIdColumnName may already exist: $e');
          }
        }

        // If you had a season_averages table and no longer need it, you could drop it here
        // if (oldVersion < 4) {
        //   await db.execute('DROP TABLE IF EXISTS season_averages');
        // }
      },
    );
    return database;
  }

  // Insert balldontlie players (league leaders)
  Future<void> insertActivePlayers(List<BdlPlayer> players) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        for (var player in players) {
          await txn.insert(
            _activePlayersTableName,
            player.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      print('An error occurred while inserting active players: $e');
    }
  }

  // Retrieve a single balldontlie player by id
  Future<BdlPlayer?> getActivePlayerById(int playerId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _activePlayersTableName,
      where: '$_activePlayerIdColumnName = ?',
      whereArgs: [playerId],
    );
    if (maps.isNotEmpty) {
      return BdlPlayer.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Retrieve all balldontlie players
  Future<List<BdlPlayer>> getAllActivePlayers() async {
    final db = await database;
    final List<Map<String, dynamic>> playerMaps =
        await db.query(_activePlayersTableName);

    List<BdlPlayer> players = playerMaps.map((playerMap) {
      return BdlPlayer.fromMap(playerMap);
    }).toList();

    return players;
  }

  // Insert Sleeper players
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

  // Get a Sleeper player by id
  Future<SleeperPlayer?> getPlayerById(String playerId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _playersTableName,
      columns: [
        // specify columns explicitly
        _playerIdColumnName,
        _playerFirstNameColumnName,
        _playerLastNameColumnName,
        _playerTeamColumnName,
        _playerNumberColumnName,
        'bdl_player_id' // include this column
      ],
      where: '$_playerIdColumnName = ?',
      whereArgs: [playerId],
    );

    if (maps.isNotEmpty) {
      return SleeperPlayer.fromJson(maps.first);
    } else {
      return null;
    }
  }

  // New method: Update a player's bdl_player_id once you've found a match
  Future<void> updatePlayerBdlId(
      String sleeperPlayerId, int bdlPlayerId) async {
    final db = await database;
    await db.update(
      _playersTableName,
      {_playerBdlIdColumnName: bdlPlayerId},
      where: '$_playerIdColumnName = ?',
      whereArgs: [sleeperPlayerId],
    );
  }

  // Optional: If you want to find all players that don't have a bdl_player_id yet
  Future<List<Map<String, dynamic>>> getPlayersWithoutBdlId() async {
    final db = await database;
    return await db.query(
      _playersTableName,
      where: '$_playerBdlIdColumnName IS NULL',
    );
  }

  Future<BdlPlayer?> getActivePlayerByNameAndNumber(
      String firstName, String lastName, String jerseyNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _activePlayersTableName,
      where:
          '$_activePlayerFirstNameColumnName = ? AND $_activePlayerLastNameColumnName = ? AND $_activePlayerJerseyNumberColumnName = ?',
      whereArgs: [firstName, lastName, jerseyNumber],
    );

    if (maps.isNotEmpty) {
      return BdlPlayer.fromMap(maps.first);
    } else {
      return null;
    }
  }
}

Future<void> matchPlayers(DatabaseService dbService) async {
  // Fetch all players who don't have a bdl_player_id set yet
  final playersWithoutBdl = await dbService.getPlayersWithoutBdlId();

  for (final sPlayerMap in playersWithoutBdl) {
    final sFirstName = sPlayerMap['first_name'] as String? ?? '';
    final sLastName = sPlayerMap['last_name'] as String? ?? '';
    final sNumber = sPlayerMap['number']?.toString() ?? '';

    if (sFirstName.isEmpty || sLastName.isEmpty || sNumber.isEmpty) {
      // If any essential field is missing, skip matching
      continue;
    }

    // Attempt to find a match in active_players
    final db = await dbService.database;
    final matches = await db.query(
      'active_players',
      where: 'first_name = ? AND last_name = ? AND jersey_number = ?',
      whereArgs: [sFirstName, sLastName, sNumber],
    );

    if (matches.length == 1) {
      // Perfect unique match found
      final match = matches.first;
      final bdlPlayerId = match['id'] as int;
      final sleeperPlayerId = sPlayerMap['player_id'] as String;

      // Update bdl_player_id in players table
      await dbService.updatePlayerBdlId(sleeperPlayerId, bdlPlayerId);
      // print('Matched $sFirstName $sLastName (#$sNumber) to bdl_player_id: $bdlPlayerId');
    } else if (matches.isEmpty) {
      // No match found - you can log or handle this case
      // print('No match found for $sFirstName $sLastName (#$sNumber)');
    } else {
      // More than one match found - ambiguous
      // Consider adding more criteria or just skipping
      // print('Multiple matches found for $sFirstName $sLastName (#$sNumber), skipping...');
    }
  }
  print('Matching completed.');
}

final bdlPlayerByIdProvider = FutureProvider.family<BdlPlayer?, int>((ref, bdlPlayerId) async {
  final dbService = DatabaseService.instance;
  return await dbService.getActivePlayerById(bdlPlayerId);
});
