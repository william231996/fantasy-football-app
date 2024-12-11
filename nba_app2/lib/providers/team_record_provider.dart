import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/team_record.dart';
import 'package:nba_app2/services/team_record_service.dart';

final standingsProvider = FutureProvider<List<TeamRecord>>((ref) async {
  final standingsService = ref.read(teamRecordsProvider);
  return await standingsService.getTeamRecords();
});