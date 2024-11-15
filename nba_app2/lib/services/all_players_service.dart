import 'dart:convert';

import 'package:nba_app2/models/sleeper_player.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AllPlayerService {
  static const String _lastUpdateKey = 'last_player_update'; // key used to store and retrieve the timestamp from SharedPreferences

  Future<List <SleeperPlayer>> getAllPlayers() async {
    var response = await http.get(
      Uri.https('api.sleeper.app', '/v1/players/nba'),
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      List<SleeperPlayer> players = result.entries.map((entry) {
        Map<String, dynamic> playerData = entry.value;
        playerData['player_id'] = entry.key;
        return SleeperPlayer.fromJson(playerData);
      }).toList();
      return players;
    } else {
      throw Exception('${response.reasonPhrase}');
    }
  }

  // checks if more than 24 hours have passed since the last update
  Future<bool> shouldFetchPlyaers() async {
    final prefs = await SharedPreferences.getInstance();
    final lastFetch = prefs.getInt(_lastUpdateKey);

    if (lastFetch == null) {
      // no previous fetch, should fetch now
      return true;
    }

    final lastFetchDate = DateTime.fromMicrosecondsSinceEpoch(lastFetch);
    final now = DateTime.now();

    // check if last fetch was more than 24 hours ago 
    return now.difference(lastFetchDate).inHours >= 24;
  }

  // update the stored timestamp after a successful data fetch
  Future<void> _updateLastFetchTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }
}
