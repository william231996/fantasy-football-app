import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nba_app2/models/bdl_player.dart';
import 'package:nba_app2/models/leader.dart';
import 'package:nba_app2/services/database_service.dart';

class LeagueLeaderService {
  final List<String> _statTypes = [
    'pts',
    'reb',
    'ast',
    'stl',
    'blk',
    'tov',
    'min'
  ];

  Future<Map<String, List<Leader>>> getLeagueLeaders2024() async {
    Map<String, List<Leader>> leadersByCategory = {};

    // For each category, fetch the leaders and then take only the top 30.
    for (var statType in _statTypes) {
      leadersByCategory[statType] = await _getLeadersForStatType(statType);
    }

    return leadersByCategory;
  }

  Future<List<Leader>> _getLeadersForStatType(String statType) async {
    try {
      // Build query parameters (season and stat_type are required)
      final queryParams = {
        'season': '2024',
        'stat_type': statType,
      };

      // Make the API call
      var response = await http.get(
        Uri.https('api.balldontlie.io', '/v1/leaders', queryParams),
        headers: {
          HttpHeaders.authorizationHeader: '${dotenv.env['API_KEY']}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        LeadersResponse leadersResponse = LeadersResponse.fromJson(data);

        // Even if the API returns more than 30 players, we limit the list to 30.
        final limitedLeaders = leadersResponse.data.take(30).toList();
        return limitedLeaders;
      } else {
        throw Exception(
            'Failed to load $statType leaders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load $statType leaders. Error: $e');
    }
  }

  Future<void> fetchAndStoreLeaderPlayers() async {
    final leadersMap = await getLeagueLeaders2024();

    // Extract unique players
    final Set<int> playerIds = {};
    final List<BdlPlayer> uniquePlayers = [];

    for (var category in leadersMap.keys) {
      for (var leader in leadersMap[category]!) {
        final p = leader.player;
        // Check if this player_id is already added
        if (!playerIds.contains(p.id)) {
          playerIds.add(p.id);

          // Ensure BdlPlayer fields align with your table schema
          // If fields in BdlPlayer match what's returned by the `player` object in the leader
          // call, no modification needed. Otherwise, default missing fields as empty or '0'.
          BdlPlayer bdlPlayer = BdlPlayer(
            id: p.id,
            first_name: p.first_name,
            last_name: p.last_name,
            height: p.height,
            weight: p.weight,
            position: p.position,
            jersey_number: p.jersey_number,
            college: p.college,
            country: p.country,
          );

          uniquePlayers.add(bdlPlayer);
        }
      }
    }

    // Now insert uniquePlayers into the database
    final databaseService = DatabaseService.instance;
    await databaseService.insertActivePlayers(uniquePlayers);
  }
}

final leagueLeadersProvider =
    Provider<LeagueLeaderService>((ref) => LeagueLeaderService());
