import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/team_record.dart';
import 'package:nba_app2/providers/team_record_provider.dart';

class StandingsPage extends ConsumerWidget {
  const StandingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsyncValue = ref.watch(standingsProvider);

    return standingsAsyncValue.when(
      data: (standings) {
        if (standings.isEmpty) {
          return const Center(
            child: Text(
              'No standings available.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        List<TeamRecord> westStandings = standings
            .where((teamRecord) => teamRecord.team.conference == 'West')
            .toList();
        westStandings
            .sort((a, b) => a.conference_rank.compareTo(b.conference_rank));

        List<TeamRecord> eastStandings = standings
            .where((teamRecord) => teamRecord.team.conference == 'East')
            .toList();
        eastStandings
            .sort((a, b) => a.conference_rank.compareTo(b.conference_rank));

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Western Conference Standings
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Western Conference',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: westStandings.length,
                itemBuilder: (context, index) {
                  final teamRecord = westStandings[index];
                  return _buildTeamRecordTile(teamRecord);
                },
              ),
              // Eastern Conference Standings
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Eastern Conference',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: eastStandings.length,
                itemBuilder: (context, index) {
                  final teamRecord = eastStandings[index];
                  return _buildTeamRecordTile(teamRecord);
                },
              ),
            ],
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

  Widget _buildTeamRecordTile(TeamRecord teamRecord) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Text(
          '${teamRecord.conference_rank}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        title: Text(
          teamRecord.team.full_name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Wins: ${teamRecord.wins} | Losses: ${teamRecord.losses}',
        ),
      ),
    );
  }
}
