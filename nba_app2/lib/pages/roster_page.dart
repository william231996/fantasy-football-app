import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app2/models/sleeper_player.dart';
import 'package:nba_app2/models/sleeper_roster.dart';
import 'package:nba_app2/providers/database_provider.dart';
import 'package:nba_app2/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/args/roster_page_args.dart';
import 'package:nba_app2/providers/roster_provider.dart';
import 'package:nba_app2/widgets/season_averages_widget.dart';

class RosterPage extends ConsumerWidget {
  final String leagueId;
  final String userId;

  const RosterPage({super.key, required this.leagueId, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterArgs = RosterPageArguments(leagueId: leagueId, userId: userId);
    final userRosterAsyncValue = ref.watch(userRosterProvider(rosterArgs));

    return userRosterAsyncValue.when(
      data: (userRosterData) {
        if (userRosterData == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Roster Not Found'),
              backgroundColor: Colors.green,
              elevation: 0.0,
            ),
            body: const Center(child: Text('No roster found for this user.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Roster'),
            backgroundColor: Colors.green,
            elevation: 0.0,
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: userRosterData.players.length,
              padding: const EdgeInsets.all(5),
              itemBuilder: (context, index) {
                final playerId = userRosterData.players[index];
                final playerAsyncValue =
                    ref.watch(playerByIdProvider(playerId));

                return playerAsyncValue.when(
                  data: (player) {
                    if (player == null) {
                      return ListTile(
                          title: Text('Player not found: $playerId'));
                    }
                    // print(
                    //     'Player ${player.first_name} ${player.last_name} has bdl_player_id: ${player.bdl_player_id}');

                    if (player == null) {
                      return ListTile(
                        title: Text('Player not found: $playerId'),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title:
                              Text('${player.first_name} ${player.last_name}'),
                          subtitle: Text('Team: ${player.team}'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            if (player.bdl_player_id == null) {
                              // No bdl_player_id? Show a simple dialog or snackbar
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('No Data'),
                                  content: Text(
                                      'No balldontlie player id found for this player.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // Show a dialog with season averages
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
                  loading: () => const ListTile(
                    title: Text('Loading player.....'),
                  ),
                  error: (error, stackTrace) => ListTile(
                    title: Text('Error loading player: $error'),
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
