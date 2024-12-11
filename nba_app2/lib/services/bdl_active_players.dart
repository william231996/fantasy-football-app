import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app2/models/bdl_player.dart';
import 'package:nba_app2/services/database_service.dart';

class ActivePlayersService {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<List<BdlPlayer>> getActivePlayers() async {
    List<BdlPlayer> allPlayers = [];
    String? nextCursor;
    int perPage = 100; // Max per_page is 100

    try {
      do {
        // Build query parameters
        Map<String, String> queryParams = {
          'per_page': perPage.toString(),
        };

        // Add cursor if it's not the first request
        if (nextCursor != null) {
          queryParams['cursor'] = nextCursor;
        }

        // Make the API call
        var response = await http.get(
          Uri.https('api.balldontlie.io', '/v1/players/active', queryParams),
          headers: {
            HttpHeaders.authorizationHeader: '${dotenv.env['API_KEY']}',
          },
        );

        if (response.statusCode == 200) {
          // print('Response for active players: ${response.body}');

          // print(response.body); // this is working
          final Map<String, dynamic> data = json.decode(response.body);

          // Extract players data
          List<dynamic> playersData = data['data'];

          // Map JSON data to BdlPlayer instances
          List<BdlPlayer> players = playersData.map((playerJson) {
            return BdlPlayer.fromJson(playerJson);
          }).toList();

          // Save players to the database
          await _databaseService.insertActivePlayers(players);

          allPlayers.addAll(players);

          // Get the next cursor
          Map<String, dynamic>? meta = data['meta'];
          nextCursor = meta != null ? meta['next_cursor'] : null;

          // print(
          //     'Fetched ${players.length} players, total ${allPlayers.length}');
          // print('nextCursor: $nextCursor');

        } else {
          throw Exception(
              'Failed to load active players. Status code: ${response.statusCode}');
        }
      } while (nextCursor != null);

      return allPlayers;
    } catch (e) {
      throw Exception('Failed to load active players. Error: $e');
    }
  }

  Future<List<BdlPlayer>> getPlayersFromDatabase() async {
    return await _databaseService.getAllActivePlayers();
  }
}

final activePlayersProvider =
    Provider<ActivePlayersService>((ref) => ActivePlayersService());
