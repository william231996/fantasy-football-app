import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/args/matchup_args.dart';
import 'package:nba_app2/models/sleeper_player.dart';
import 'package:nba_app2/providers/matchup_provider.dart';
import 'package:nba_app2/providers/player_by_ID_provider.dart';
import 'package:nba_app2/providers/roster_provider.dart';
import 'package:nba_app2/providers/scroll_controller_provider.dart';
import 'package:nba_app2/providers/season_details_provider.dart';
import 'package:nba_app2/providers/user_provider.dart';
import 'package:nba_app2/services/matchups_service.dart';
import 'package:nba_app2/services/roster_service.dart';

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
                    .findOpponentMatchup(
                        matchups, myMatchup.matchup_id);
                if (opponentMatchup == null) {
                  return const Center(child: Text('No opponent matchup found'));
                }

                final opponentRoster = ref
                    .read(rosterServiceProvider)
                    .findRosterByRosterId(rosters, opponentMatchup.roster_id);
                if (opponentRoster == null) {
                  return const Center(child: Text('No opponent roster found'));
                }

                final myStarterIds =
                    (myRoster.starters).whereType<String>().toList();
                final opponentStarterIds =
                    (opponentRoster.starters).whereType<String>().toList();

                final myStartersAsyncValue = myStarterIds.map((playerId) {
                  return ref.watch(playerByIdProvider(playerId));
                }).toList();

                final opponentStartersAsyncValue =
                    opponentStarterIds.map((playerId) {
                  return ref.watch(playerByIdProvider(playerId));
                }).toList();

                bool myStartersAllLoaded = myStartersAsyncValue
                    .every((playerAsyncValue) => playerAsyncValue.hasValue);

                bool opponentStartersAllLoaded = opponentStartersAsyncValue
                    .every((playerAsyncValue) => playerAsyncValue.hasValue);

                if (myStartersAllLoaded && opponentStartersAllLoaded) {
                  final myPlayers = myStartersAsyncValue
                      .map((playerAsyncValue) => playerAsyncValue.value)
                      .whereType<SleeperPlayer>()
                      .toList();
                  final opponentPlayers = opponentStartersAsyncValue
                      .map((playerAsyncValue) => playerAsyncValue.value)
                      .whereType<SleeperPlayer>()
                      .toList();

                  return Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildPlayerList(
                                    myPlayers, myScrollController),
                              ),
                              Expanded(
                                child: _buildPlayerList(
                                    opponentPlayers, opponentScrollController),
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
                      title: Text('Loading Players...'),
                      backgroundColor: Colors.green,
                      elevation: 0.0,
                    ),
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                // return Scaffold(
                //   body: ListView(
                //     children: [
                //       ListTile(
                //         title: Text('My Roster'),
                //         subtitle: Text('Roster ID: ${myRoster.roster_id}'),
                //       ),
                //       ListTile(
                //         title: Text('Opponent Roster'),
                //         subtitle:
                //             Text('Roster ID: ${opponentRoster.roster_id}'),
                //       ),
                //     ],
                //   ),
                // );
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

  // Method to build player list
  Widget _buildPlayerList(
      List<SleeperPlayer> players, ScrollController controller) {
    return Container(
      height: 1000, // Set a fixed height to allow scrolling
      child: ListView.builder(
        controller: controller,
        itemCount: players.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text('${players[index].first_name} ${players[index].last_name}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
