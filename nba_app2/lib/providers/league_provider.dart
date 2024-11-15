import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/sleeper_leagues.dart';
import 'package:nba_app2/services/leagues_service.dart';

final leagueDataProvider = FutureProvider.family<List<SleeperLeagues>, String>((ref, userId) async {
  return ref.watch(leagueProvider).getLeagues(userId);
});