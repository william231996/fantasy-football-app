import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/services/database_service.dart';
import 'package:nba_app2/services/season_averages.dart';

// class SeasonAveragesDialog extends ConsumerWidget {
//   final int bdlPlayerId;
//   const SeasonAveragesDialog({Key? key, required this.bdlPlayerId}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final averagesAsyncValue = ref.watch(seasonAveragesProvider(bdlPlayerId));

//     return averagesAsyncValue.when(
//       data: (avg) {
//         if (avg == null) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text('No season averages found for this player.'),
//           );
//         }

//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Season Averages (2024)', style: TextStyle(fontWeight: FontWeight.bold)),
//               SizedBox(height: 8),
//               Text('PTS: ${avg.pts.toStringAsFixed(1)}'),
//               Text('REB: ${avg.reb.toStringAsFixed(1)}'),
//               Text('AST: ${avg.ast.toStringAsFixed(1)}'),
//               Text('STL: ${avg.stl.toStringAsFixed(1)}'),
//               Text('BLK: ${avg.blk.toStringAsFixed(1)}'),
//               Text('FG%: ${(avg.fg_pct * 100).toStringAsFixed(1)}%'),
//               Text('3P%: ${(avg.fg3_pct * 100).toStringAsFixed(1)}%'),
//               Text('FT%: ${(avg.ft_pct * 100).toStringAsFixed(1)}%'),
//               Text('Games Played: ${avg.games_played}'),
//               SizedBox(height: 8),
//               ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Close'))
//             ],
//           ),
//         );
//       },
//       loading: () => Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(child: CircularProgressIndicator()),
//       ),
//       error: (error, stack) => Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text('Error: $error'),
//       ),
//     );
//   }
// }

class SeasonAveragesDialog extends ConsumerWidget {
  final int bdlPlayerId;
  const SeasonAveragesDialog({Key? key, required this.bdlPlayerId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final averagesAsyncValue = ref.watch(seasonAveragesProvider(bdlPlayerId));
    final playerAsyncValue = ref.watch(bdlPlayerByIdProvider(bdlPlayerId));

    // We need both player and averages data. We can do nested `when` calls:
    return playerAsyncValue.when(
      data: (player) {
        // player can be null if not found
        final playerName = (player != null)
            ? '${player.first_name} ${player.last_name}'
            : 'Player';

        return averagesAsyncValue.when(
          data: (avg) {
            if (avg == null) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('No season averages found for $playerName.'),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$playerName',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Season Averages (2024)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('PTS: ${avg.pts.toStringAsFixed(1)}'),
                  Text('REB: ${avg.reb.toStringAsFixed(1)}'),
                  Text('AST: ${avg.ast.toStringAsFixed(1)}'),
                  Text('STL: ${avg.stl.toStringAsFixed(1)}'),
                  Text('BLK: ${avg.blk.toStringAsFixed(1)}'),
                  Text('FG%: ${(avg.fg_pct * 100).toStringAsFixed(1)}%'),
                  Text('3P%: ${(avg.fg3_pct * 100).toStringAsFixed(1)}%'),
                  Text('FT%: ${(avg.ft_pct * 100).toStringAsFixed(1)}%'),
                  Text('Games Played: ${avg.games_played}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error: $error'),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Error: $error'),
      ),
    );
  }
}
