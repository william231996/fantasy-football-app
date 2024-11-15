import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app2/services/matchups_service.dart';

class SeasonService {
  Future<int> getCurrentWeek() async {
    try {
      var response = await http.get(
        Uri.https('api.sleeper.app', '/v1/state/nba'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        final int currentWeek = result['display_week'];
        return currentWeek;
      } else {
        print(
            'failed to load current week. Status code: ${response.statusCode}');
        return 1;
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      return Future.error(e, stackTrace);
    }
  }
}

final seasonServiceProvider = Provider<SeasonService>((ref) => SeasonService());
