import 'package:nba_app2/models/team.dart';

class TeamRecord {
  final Team team;
  final int conference_rank;
  final int wins;
  final int losses;
  TeamRecord({
    required this.team,
    required this.conference_rank,
    required this.wins,
    required this.losses,
  });
    factory TeamRecord.fromJson(Map<String, dynamic> json) {
        return TeamRecord(
        team: Team.fromJson(json['team']),
        conference_rank: json['conference_rank'] ?? 0,
        wins: json['wins'] ?? 0,
        losses: json['losses'] ?? 0,
        );
    }
}