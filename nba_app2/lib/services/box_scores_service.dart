import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app2/models/box_scores.dart';

class BoxScoresService {
  Future getLiveBoxScores() async {
    try {
      var response = await http.get(
        Uri.https('api.balldontlie.io', '/v1/box_scores/live'),
        headers: {
          HttpHeaders.authorizationHeader: '${dotenv.env['API_KEY']}',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // extract list of games from the response
        List<dynamic> games = data['data'];

        // map each game to a boxscore instance
        List<BoxScore> boxScores = games.map((gameJson) {
          return BoxScore.fromJson(gameJson);
        }).toList();

        return boxScores;
      } else {
        throw Exception(
            'Failed to load box scores. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load box scores. Error: $e');
    }
  }
}

final boxScoresProvider = Provider<BoxScoresService>((ref) => BoxScoresService());