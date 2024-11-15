import 'package:nba_app2/args/roster_page_args.dart';
import 'package:nba_app2/models/sleeper_roster.dart';
import 'package:nba_app2/services/roster_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rosterDataProvider =
    FutureProvider.family<List<SleeperRoster>, String>((ref, leagueId) async {
  final rosterService = ref.read(rosterServiceProvider);
  return await rosterService.getRosters(leagueId);
});

final userRosterProvider =
    FutureProvider.family<SleeperRoster?, RosterPageArguments>(
        (ref, args) async {
  final rosterService = ref.read(rosterServiceProvider);
  return await rosterService.getUserRoster(args.leagueId, args.userId);
});


