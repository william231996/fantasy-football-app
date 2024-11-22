import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/sleeper_player.dart';
import 'package:nba_app2/providers/database_provider.dart';
import 'package:nba_app2/services/all_players_service.dart';

final allPlayerServiceProvider = Provider<AllPlayerService>((ref) {
  return AllPlayerService();
});

final playerDataInitializationProvider = FutureProvider<void>((ref) async {
  final playerService = ref.read(allPlayerServiceProvider);
  final databaseService = ref.read(databaseServiceProvider);

  bool shouldFetch = await playerService.shouldFetchPlayers();

  if (shouldFetch) {
    try {
      List<SleeperPlayer> players = await playerService.getAllPlayers();
      await databaseService.insertPlayers(players); 
      print('Players data updated.');
    } catch (e) {
      print('An error ocurred while updating players: $e');
    }
  } else {
    print('Players data is up to date.');
  }
});