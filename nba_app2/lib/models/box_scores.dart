import 'package:nba_app2/models/team.dart';

class BoxScore {
  final String date;
  final int home_team_score;
  final int visitor_team_score;
  final String time;
  final Team home_team;
  final Team visitor_team;
  BoxScore({
    required this.date,
    required this.home_team_score,
    required this.visitor_team_score,
    required this.time,
    required this.home_team,
    required this.visitor_team,
  });
    factory BoxScore.fromJson(Map<String, dynamic> json) {
    return BoxScore(
      date: json['date'] ?? '',
      home_team_score: json['home_team_score'] ?? 0,
      visitor_team_score: json['visitor_team_score'] ?? 0,
      time: json['time'] ?? '',
      home_team: Team.fromJson(json['home_team']),
      visitor_team: Team.fromJson(json['visitor_team']),
    );
  }
}