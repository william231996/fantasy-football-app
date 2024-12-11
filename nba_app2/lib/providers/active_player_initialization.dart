import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/bdl_player.dart';
import 'package:nba_app2/services/bdl_active_players.dart';
import 'package:nba_app2/services/database_service.dart';

final activePlayersInitializationProvider = FutureProvider<void>((ref) async {
  final activePlayersService = ref.read(activePlayersProvider);

  // Try to retrieve players from the database
  List<BdlPlayer> players = await activePlayersService.getPlayersFromDatabase();

  await activePlayersService.getActivePlayers();


  // if (players.isEmpty) {
  //   // If no data in the database, fetch from API and save to database
  //   try {
  //     await activePlayersService.getActivePlayers();
  //     print('Active players data updated.');
  //   } catch (e) {
  //     print('An error occurred while updating active players: $e');
  //   }
  // } else {
  //   print('Active players data is up to date.');
  // }

  // final dbService = DatabaseService.instance;
  // BdlPlayer? player =
  //     await dbService.getActivePlayerByNameAndNumber('Cameron', 'Johnson', '2');

  // if (player != null) {
  //   print(
  //       'Found player: ${player.first_name} ${player.last_name}, ID: ${player.id}');
  // } else {
  //   print('No matching player found.');
  // }
});
