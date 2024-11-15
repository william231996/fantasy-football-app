import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/args/matchup_args.dart';
import 'package:nba_app2/models/sleeper_matchups.dart';
import 'package:nba_app2/services/matchups_service.dart';

final matchupsProvider = FutureProvider.family<List<SleeperMatchups>, MatchupArgs>((ref, args) async {
  final matchUpService = ref.read(matchupServiceProvider);
  return await matchUpService.getMatchups(args.leagueId, args.week);
});