import 'package:nba_app2/services/all_players_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allPlayerServiceProvider = Provider<AllPlayerService>((ref) {
  return AllPlayerService();
});