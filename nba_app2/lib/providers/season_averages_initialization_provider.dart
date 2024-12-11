import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/season_averages.dart';
import 'package:nba_app2/providers/active_player_initialization.dart';
import 'package:nba_app2/services/league_leaders_service.dart';

// final seasonAveragesInitializationProvider = FutureProvider<void>((ref) async {
//   // Wait for the active players initialization to complete
//   await ref.read(activePlayersInitializationProvider.future);

//   final leagueLeadersService = LeagueLeaderService();

//   // Fetch and store season averages if not already in the database
//   List<SeasonAverage> seasonAverages =
//       await leagueLeadersService.getSeasonAverages(2024);

//   if (seasonAverages.isEmpty) {
//     await leagueLeadersService.fetchAndStoreSeasonAverages(2024);
//     print('Season averages data updated.');
//   } else {
//     print('Season averages data is up to date.');
//   }
// });