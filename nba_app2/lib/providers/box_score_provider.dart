
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/box_scores.dart';
import 'package:nba_app2/services/box_scores_service.dart';

final liveBoxScoresProvider = FutureProvider<List<BoxScore>>((ref) async {
  final boxScoresService = ref.read(boxScoresProvider);
  return await boxScoresService.getLiveBoxScores();
});