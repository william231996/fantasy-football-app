import 'package:nba_app2/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/sleeper_player.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});

final playerByIdProvider = FutureProvider.family<SleeperPlayer?, String>((ref, playerId) async {
  final databaseService = ref.read(databaseServiceProvider);
  return await databaseService.getPlayerById(playerId);
});