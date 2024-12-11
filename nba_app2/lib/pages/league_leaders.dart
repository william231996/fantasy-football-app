import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/providers/league_leaders_provider.dart';

class LeagueLeadersPage extends ConsumerWidget {
  const LeagueLeadersPage({Key? key}) : super(key: key);

  // A helper map to convert stat_type keys to user-friendly display names.
  final Map<String, String> statDisplayNames = const {
    'pts': 'Points',
    'reb': 'Rebounds',
    'ast': 'Assists',
    'stl': 'Steals',
    'blk': 'Blocks',
    'tov': 'Turnovers',
    'min': 'Minutes',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadersAsyncValue = ref.watch(myLeagueLeadersFutureProvider);

    return Scaffold(
      body: leadersAsyncValue.when(
        data: (leadersMap) {
          // leadersMap is Map<String, List<Leader>>
          // Sort the categories by a preferred order (optional)
          final categories = ['pts', 'reb', 'ast', 'stl', 'blk', 'tov', 'min'];

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final statType = categories[index];
              final categoryName = statDisplayNames[statType] ?? statType.toUpperCase();
              final leaders = leadersMap[statType] ?? [];

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(
                    categoryName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    // Provide a fixed height container to allow scrolling
                    Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: leaders.length,
                        itemBuilder: (context, leaderIndex) {
                          final leader = leaders[leaderIndex];
                          final player = leader.player;
                          return ListTile(
                            leading: Text('${leader.rank}'),
                            title: Text('${player.first_name} ${player.last_name}'),
                            subtitle: Text(
                              '${leader.stat_type.toUpperCase()}: ${leader.value.toStringAsFixed(1)}',
                            ),
                            trailing: Text('GP: ${leader.games_played}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
      ),
    );
  }
}