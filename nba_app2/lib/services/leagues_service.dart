import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/sleeper_leagues.dart';
import 'package:http/http.dart' as http;

class LeagueService {
  Future<List<SleeperLeagues>> getLeagues(String userId) async {
    var response = await http.get(
      Uri.https('api.sleeper.app', '/v1/user/$userId/leagues/nba/2024'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body);
      return result.map(((e) => SleeperLeagues.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final leagueProvider = Provider<LeagueService>((ref) => LeagueService());