import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/args/matchup_args.dart';
import 'package:nba_app2/models/sleeper_player.dart';
import 'package:nba_app2/providers/database_provider.dart';
import 'package:nba_app2/providers/matchup_provider.dart';
import 'package:nba_app2/providers/roster_provider.dart';
import 'package:nba_app2/providers/scroll_controller_provider.dart';
import 'package:nba_app2/providers/season_details_provider.dart';
import 'package:nba_app2/providers/user_provider.dart';
import 'package:nba_app2/services/matchups_service.dart';
import 'package:nba_app2/services/roster_service.dart';
import 'package:nba_app2/widgets/season_averages_widget.dart';

class MatchupPage extends ConsumerWidget {
  final String leagueId;
  final String userId;

  const MatchupPage({super.key, required this.leagueId, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollControllers = ref.watch(scrollControllersProvider);
    final myScrollController = scrollControllers.myScrollController;
    final opponentScrollController = scrollControllers.opponentScrollController;

    final currentWeekAsyncValue = ref.watch(currentWeekProvider);
    final rostersAsyncValue = ref.watch(rosterDataProvider(leagueId));

    return currentWeekAsyncValue.when(
      data: (currentWeek) {
        return rostersAsyncValue.when(
          data: (rosters) {
            final myRoster = ref
                .read(rosterServiceProvider)
                .findRosterByUserId(rosters, userId);
            if (myRoster == null) {
              return const Center(child: Text('No roster found'));
            }

            final matchupsAsyncValue = ref.watch(matchupsProvider(
                MatchupArgs(leagueId: leagueId, week: currentWeek)));
            return matchupsAsyncValue.when(
              data: (matchups) {
                final myMatchup = ref
                    .read(matchupServiceProvider)
                    .findMatchupByRosterId(matchups, myRoster.roster_id);
                if (myMatchup == null) {
                  return const Center(child: Text('No matchup found'));
                }

                final opponentMatchup = ref
                    .read(matchupServiceProvider)
                    .findOpponentMatchup(matchups, myMatchup.matchup_id);
                if (opponentMatchup == null) {
                  return const Center(child: Text('No opponent matchup found'));
                }

                final opponentRoster = ref
                    .read(rosterServiceProvider)
                    .findRosterByRosterId(rosters, opponentMatchup.roster_id);
                if (opponentRoster == null) {
                  return const Center(child: Text('No opponent roster found'));
                }

                // Separate starters and bench for my roster
                final myStarterIds =
                    (myRoster.starters).whereType<String>().toList();
                final myAllPlayerIds =
                    (myRoster.players).whereType<String>().toList();
                final myBenchIds = myAllPlayerIds
                    .where((p) => !myStarterIds.contains(p))
                    .toList();

                // Separate starters and bench for opponent roster
                final opponentStarterIds =
                    (opponentRoster.starters).whereType<String>().toList();
                final opponentAllPlayerIds =
                    (opponentRoster.players).whereType<String>().toList();
                final opponentBenchIds = opponentAllPlayerIds
                    .where((p) => !opponentStarterIds.contains(p))
                    .toList();

                // Watch all starters and bench for my roster
                final myStartersAsyncValue = myStarterIds
                    .map((id) => ref.watch(playerByIdProvider(id)))
                    .toList();
                final myBenchAsyncValue = myBenchIds
                    .map((id) => ref.watch(playerByIdProvider(id)))
                    .toList();

                // Watch all starters and bench for opponent roster
                final opponentStartersAsyncValue = opponentStarterIds
                    .map((id) => ref.watch(playerByIdProvider(id)))
                    .toList();
                final opponentBenchAsyncValue = opponentBenchIds
                    .map((id) => ref.watch(playerByIdProvider(id)))
                    .toList();

                // Check if all starters and bench players are loaded for both rosters
                bool myAllLoaded = [
                  ...myStartersAsyncValue,
                  ...myBenchAsyncValue
                ].every((val) => val.hasValue);
                bool opponentAllLoaded = [
                  ...opponentStartersAsyncValue,
                  ...opponentBenchAsyncValue
                ].every((val) => val.hasValue);

                if (myAllLoaded && opponentAllLoaded) {
                  final myStarters = myStartersAsyncValue
                      .map((val) => val.value)
                      .whereType<SleeperPlayer>()
                      .toList();
                  final myBench = myBenchAsyncValue
                      .map((val) => val.value)
                      .whereType<SleeperPlayer>()
                      .toList();

                  final opponentStarters = opponentStartersAsyncValue
                      .map((val) => val.value)
                      .whereType<SleeperPlayer>()
                      .toList();
                  final opponentBench = opponentBenchAsyncValue
                      .map((val) => val.value)
                      .whereType<SleeperPlayer>()
                      .toList();

                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Matchups'),
                      backgroundColor: Colors.green,
                      elevation: 0.0,
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildPlayerList("My Starters", myStarters,
                                        myScrollController),
                                    const SizedBox(height: 20),
                                    _buildPlayerList("My Bench", myBench,
                                        myScrollController),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildPlayerList(
                                        "Opponent Starters",
                                        opponentStarters,
                                        opponentScrollController),
                                    const SizedBox(height: 20),
                                    _buildPlayerList(
                                        "Opponent Bench",
                                        opponentBench,
                                        opponentScrollController),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Loading Players...'),
                      backgroundColor: Colors.green,
                      elevation: 0.0,
                    ),
                    body: const Center(child: CircularProgressIndicator()),
                  );
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text('Error: $error'),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Text('Error: $error'),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }

  Widget _buildPlayerList(String heading, List<SleeperPlayer> players,
      ScrollController controller) {
    return Container(
      height: 600, // adjust as necessary
      child: Column(
        children: [
          Text(heading,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('${player.first_name} ${player.last_name}'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        if (player.bdl_player_id == null) {
                          // No bdl_player_id? Show a dialog or snackbar
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('No Data'),
                              content: const Text(
                                  'No balldontlie player id found for this player.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Show season averages
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: SeasonAveragesDialog(
                                    bdlPlayerId: player.bdl_player_id!),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class MatchupPage extends ConsumerWidget {
//   final String leagueId;
//   final String userId;

//   const MatchupPage({super.key, required this.leagueId, required this.userId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final scrollControllers = ref.watch(scrollControllersProvider);
//     final myScrollController = scrollControllers.myScrollController;
//     final opponentScrollController = scrollControllers.opponentScrollController;

//     final currentWeekAsyncValue = ref.watch(currentWeekProvider);
//     final rostersAsyncValue = ref.watch(rosterDataProvider(leagueId));

//     return currentWeekAsyncValue.when(
//       data: (currentWeek) {
//         return rostersAsyncValue.when(
//           data: (rosters) {
//             final myRoster = ref
//                 .read(rosterServiceProvider)
//                 .findRosterByUserId(rosters, userId);
//             if (myRoster == null) {
//               return const Center(child: Text('No roster found'));
//             }

//             final matchupsAsyncValue = ref.watch(matchupsProvider(
//                 MatchupArgs(leagueId: leagueId, week: currentWeek)));
//             return matchupsAsyncValue.when(
//               data: (matchups) {
//                 final myMatchup = ref
//                     .read(matchupServiceProvider)
//                     .findMatchupByRosterId(matchups, myRoster.roster_id);
//                 if (myMatchup == null) {
//                   return const Center(child: Text('No matchup found'));
//                 }

//                 final opponentMatchup = ref
//                     .read(matchupServiceProvider)
//                     .findOpponentMatchup(matchups, myMatchup.matchup_id);
//                 if (opponentMatchup == null) {
//                   return const Center(child: Text('No opponent matchup found'));
//                 }

//                 final opponentRoster = ref
//                     .read(rosterServiceProvider)
//                     .findRosterByRosterId(rosters, opponentMatchup.roster_id);
//                 if (opponentRoster == null) {
//                   return const Center(child: Text('No opponent roster found'));
//                 }

//                 final myStarterIds =
//                     (myRoster.players).whereType<String>().toList();
//                 final opponentStarterIds =
//                     (opponentRoster.players).whereType<String>().toList();

//                 final myStartersAsyncValue = myStarterIds.map((playerId) {
//                   return ref.watch(playerByIdProvider(playerId));
//                 }).toList();

//                 final opponentStartersAsyncValue =
//                     opponentStarterIds.map((playerId) {
//                   return ref.watch(playerByIdProvider(playerId));
//                 }).toList();

//                 bool myStartersAllLoaded = myStartersAsyncValue
//                     .every((playerAsyncValue) => playerAsyncValue.hasValue);

//                 bool opponentStartersAllLoaded = opponentStartersAsyncValue
//                     .every((playerAsyncValue) => playerAsyncValue.hasValue);

//                 if (myStartersAllLoaded && opponentStartersAllLoaded) {
//                   final myPlayers = myStartersAsyncValue
//                       .map((playerAsyncValue) => playerAsyncValue.value)
//                       .whereType<SleeperPlayer>()
//                       .toList();
//                   final opponentPlayers = opponentStartersAsyncValue
//                       .map((playerAsyncValue) => playerAsyncValue.value)
//                       .whereType<SleeperPlayer>()
//                       .toList();

//                   return Scaffold(
//                     appBar: AppBar(
//                       title: const Text('Matchups'),
//                       backgroundColor: Colors.green,
//                       elevation: 0.0,
//                     ),
//                     body: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: _buildPlayerList(
//                                     myPlayers, myScrollController),
//                               ),
//                               Expanded(
//                                 child: _buildPlayerList(
//                                     opponentPlayers, opponentScrollController),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 } else {
//                   return Scaffold(
//                     appBar: AppBar(
//                       title: Text('Loading Players...'),
//                       backgroundColor: Colors.green,
//                       elevation: 0.0,
//                     ),
//                     body: Center(child: CircularProgressIndicator()),
//                   );
//                 }
//               },
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (error, stackTrace) => Text('Error: $error'),
//             );
//           },
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (error, stackTrace) => Text('Error: $error'),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (error, stackTrace) => Text('Error: $error'),
//     );
//   }

//   // Method to build player list
//   Widget _buildPlayerList(
//       List<SleeperPlayer> players, ScrollController controller) {
//     return Container(
//       height: 1000, // Set a fixed height to allow scrolling
//       child: ListView.builder(
//         controller: controller,
//         itemCount: players.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.greenAccent,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: ListTile(
//                 title: Text(
//                     '${players[index].first_name} ${players[index].last_name}'),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
