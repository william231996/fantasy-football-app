import 'package:nba_app2/services/season_details_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentWeekProvider = FutureProvider<int>((ref) async {
  final seasonService = ref.read(seasonServiceProvider);
  return await seasonService.getCurrentWeek();
});