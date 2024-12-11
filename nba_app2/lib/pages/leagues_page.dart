import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/args/roster_page_args.dart';
import 'package:nba_app2/providers/bdl_active_players_provider.dart';
import 'package:nba_app2/providers/database_provider.dart';
import 'package:nba_app2/providers/player_initialization_provider.dart';
import 'package:nba_app2/providers/user_league_provider.dart';
import 'package:nba_app2/services/database_service.dart';

class LeaguesPage extends ConsumerWidget {
  final String username;

  const LeaguesPage({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsyncValue = ref.watch(teamDataProvider(username));
    final initialization = ref.watch(combinedInitializationProvider);

    return initialization.when(data: (_) {
      return teamAsyncValue.when(
        data: (teamData) {
          final user = teamData.user;
          final leagues = teamData.leagues;

          return Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('${user.username} Leagues'),
              ),
              centerTitle: true,
              backgroundColor: Colors.green,
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
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text('League Name: ${leagues[index].name}'),
                        subtitle: Text(
                            'Sport: ${leagues[index].sport.toUpperCase()}'),
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
    }, loading: () {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }, error: (err, stack) {
      return Scaffold(
        body: Center(
          child: Text('Error: $err'),
        ),
      );
    });
  }
}
