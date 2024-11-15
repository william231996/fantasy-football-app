import 'dart:convert';

import 'package:nba_app2/models/sleeper_roster.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RosterService {
  Future<List<SleeperRoster>> getRosters(String leagueId) async {
    try {
      // print('fetching roster for league ID: $leagueId, owner ID: $userId');// checkpoint
      var response = await http.get(
        Uri.https('api.sleeper.app', '/v1/league/$leagueId/rosters'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);
        final rosters = result.map((e) => SleeperRoster.fromJson(e)).toList();
        return rosters;
      } else {
        print('failed to load rosters. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to load rosters. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      return Future.error(e, stackTrace);
    }
  }

  Future<SleeperRoster?> getUserRoster(String leagueId, String userId) async {
    try {
      final rosters = await getRosters(leagueId);

      for (var roster in rosters) {
        if (roster?.owner_id != null &&
            roster?.owner_id.toString() == userId.toString()) {
          print('Match found');
          return roster;
        }
      }
      print('No match found');
      return null;
    } catch (e, stackTrace) {
      print('Error: $e');
      return Future.error(e, stackTrace);
    }
  }

  SleeperRoster? findRosterByUserId(
      List<SleeperRoster?> rosters, String userId) {
    for (var roster in rosters) {
      if (roster != null && roster.owner_id == userId) {
        return roster;
      }
    }
    return null;
  }

  SleeperRoster? findRosterByRosterId(
      List<SleeperRoster?> rosters, int rosterId) {
    for (var roster in rosters) {
      if (roster != null && roster.roster_id == rosterId) {
        return roster;
      }
    }
    return null;
  }
}

final rosterServiceProvider = Provider<RosterService>((ref) => RosterService());
