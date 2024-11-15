import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/sleeper_matchups.dart';

class MatchUpService {
  Future<List<SleeperMatchups>> getMatchups(String leagueId, int week) async {
    try {
 // checkpoint
      var response = await http.get(
        Uri.https('api.sleeper.app', '/v1/league/$leagueId/matchups/$week'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);
        final matchups =
            result.map((e) => SleeperMatchups.fromJson(e)).toList();
        return matchups;
      } else {
        print('failed to load matchups. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      return Future.error(e, stackTrace);
    }
  }

  SleeperMatchups? findMatchupByRosterId(
      List<SleeperMatchups> matchups, int rosterId) {
    return matchups.firstWhere(
      (matchup) => matchup.roster_id == rosterId,
      orElse: () => SleeperMatchups(
        roster_id: 0,
        matchup_id: 0,
        points: 0.0,
        players: [],
        starters: [],
      ), // Provide a default SleeperMatchups object
    );
  }

  SleeperMatchups? findOpponentMatchup(
      List<SleeperMatchups> matchups, int matchupId) {
    return matchups.firstWhere(
      (matchup) =>
          matchup.matchup_id == matchupId,
      orElse: () => SleeperMatchups(
        roster_id: 0,
        matchup_id: 0,
        points: 0.0,
        players: [],
        starters: [],
      ),
    );
  }
}

final matchupServiceProvider =
    Provider<MatchUpService>((ref) => MatchUpService());
