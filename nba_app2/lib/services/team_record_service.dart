import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app2/models/team_record.dart';
import 'package:nba_app2/services/box_scores_service.dart';

class TeamRecordService {
  Future getTeamRecords() async {
    try {
      var response = await http.get(
        Uri.https('api.balldontlie.io', '/v1/standings', {'season': '2024'}),
        headers: {
          HttpHeaders.authorizationHeader: '${dotenv.env['API_KEY']}',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        List<dynamic> record = data['data'];

        List<TeamRecord> teamRecords = record.map((gameJson) {
          return TeamRecord.fromJson(gameJson);
        }).toList();

        return teamRecords;
      } else {
        throw Exception(
            'Failed to load team records. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load team records. Error: $e');
    }
  }
}

final teamRecordsProvider =
    Provider<TeamRecordService>((ref) => TeamRecordService());
