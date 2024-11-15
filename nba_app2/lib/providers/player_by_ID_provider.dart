import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/providers/database_provider.dart';
import '../models/sleeper_player.dart';

final playerByIdProvider = FutureProvider.family<SleeperPlayer?, String>((ref, playerId) async {
  final databaseService = ref.read(databaseServiceProvider);
  return await databaseService.getPlayerById(playerId);
});