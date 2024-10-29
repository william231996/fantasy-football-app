import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/args/roster_page_args.dart';
import 'package:nba_app2/models/sleeper_leagues.dart';
import 'package:nba_app2/models/sleeper_user.dart';
import 'package:nba_app2/providers/league_provider.dart';
import 'package:nba_app2/providers/user_league_provider.dart';
import 'package:nba_app2/providers/user_provider.dart';
import 'package:nba_app2/services/user_service.dart';
import 'package:http/http.dart' as http;

class TeamPage extends ConsumerWidget {
  final String username;

  const TeamPage({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsyncValue = ref.watch(teamDataProvider(username));

    return teamAsyncValue.when(
      data: (teamData) {
        final user = teamData.user;
        final leagues = teamData.leagues;

        return Scaffold(
          appBar: AppBar(
            title: Text('${user.username} Leagues'),
            backgroundColor: Colors.green,
            elevation: 0.0,
          ),
          body: SafeArea(
            child: ListView.builder(
              itemCount: leagues.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('League Name: ${leagues[index].name}'),
                      subtitle: Text(
                          'Season: ${leagues[index].season} Sport: ${leagues[index].sport}'),
                      // on tap sends the league id to the roster page
                      onTap: () {
                        var leagueId = leagues[index].league_id;
                        var userId = user.user_id;
                        Navigator.of(context).pushNamed('/roster',
                            arguments: RosterPageArguments(
                              leagueId: leagueId,
                              userId: userId,
                            ));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
