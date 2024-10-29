class Game {
  final int id;
  final String date;
  final int season;
  final int home_team_score;
  final int visitor_team_score;
  final int home_team_id;
  final int visitor_team_id;

  Game({
    required this.id,
    required this.date,
    required this.season,
    required this.home_team_score,
    required this.visitor_team_score,
    required this.home_team_id,
    required this.visitor_team_id,
  });
}