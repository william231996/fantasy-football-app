import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/season_averages.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app2/models/sleeper_player.dart';
import 'package:nba_app2/services/database_service.dart';

final seasonAveragesProvider = FutureProvider.family<SeasonAverage?, int>((ref, bdlPlayerId) async {
  final season = 2024; // or make this configurable
  final queryParams = {
    'season': season.toString(),
    'player_id': bdlPlayerId.toString(),
  };

  final response = await http.get(
    Uri.https('api.balldontlie.io', '/v1/season_averages', queryParams),
    headers: {
      HttpHeaders.authorizationHeader: '${dotenv.env['API_KEY']}',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> averagesData = data['data'];

    if (averagesData.isNotEmpty) {
      return SeasonAverage.fromJson(averagesData.first);
    } else {
      return null; // no averages for this player/season
    }
  } else {
    throw Exception('Failed to load season averages. Status code: ${response.statusCode}');
  }
});

final playerByIdProvider = FutureProvider.family<SleeperPlayer?, String>((ref, playerId) async {
  final dbService = DatabaseService.instance;
  return await dbService.getPlayerById(playerId);
});