import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/leader.dart';
import 'package:nba_app2/services/league_leaders_service.dart';

final myLeagueLeadersFutureProvider = FutureProvider<Map<String, List<Leader>>>((ref) async {
  final service = ref.read(leagueLeadersProvider);
  return await service.getLeagueLeaders2024();
});