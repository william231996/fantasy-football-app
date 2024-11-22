import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/providers/box_score_provider.dart';

class BoxScoresPage extends ConsumerWidget {
  const BoxScoresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxScoresAsyncValue = ref.watch(liveBoxScoresProvider);

    Future<void> _refresh() async {
      // refresh the box scores
      await Future.delayed(const Duration(seconds: 2));
      ref.refresh(liveBoxScoresProvider);
    }

    return boxScoresAsyncValue.when(
      data: (boxScores) {
        if (boxScores.isEmpty) {
          return const Center(
            child: Text('No live games'),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          color: Colors.white,
          backgroundColor: Colors.green,
          child: ListView.builder(
            itemCount: boxScores.length,
            itemBuilder: (context, index) {
              final boxScore = boxScores[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: ListTile(
                  title: Text(
                      '${boxScore.visitor_team.full_name} - ${boxScore.home_team.full_name}'),
                  subtitle: Text(
                      '${boxScore.visitor_team_score} - ${boxScore.home_team_score}'),
                  trailing: Text(boxScore.time),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
