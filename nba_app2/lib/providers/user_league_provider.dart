import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/sleeper_leagues.dart';
import 'package:nba_app2/models/sleeper_user.dart';
import 'package:nba_app2/services/leagues_service.dart';
import 'package:nba_app2/services/user_service.dart';

final teamDataProvider = FutureProvider.family<TeamData, String>((ref, username) async {
  final user = await ref.watch(userProvider).getSleeperUser(username);
  final leagues = await ref.watch(leagueProvider).getLeagues(user.user_id);
  return TeamData(user: user, leagues: leagues);
});

class TeamData {
  final SleeperUser user;
  final List<SleeperLeagues> leagues;

  TeamData({required this.user, required this.leagues});
}