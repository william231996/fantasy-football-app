class SleeperMatchups {
  final int roster_id;
  final int matchup_id;
  final num points;
  final List<String> players;
  final List<String> starters;
  SleeperMatchups({
    required this.roster_id,
    required this.matchup_id,
    required this.points,
    required this.players,
    required this.starters,
  });
  factory SleeperMatchups.fromJson(Map<String, dynamic> json) {
    return SleeperMatchups(
      roster_id: json['roster_id'] ?? 0,
      matchup_id: json['matchup_id'] ?? 0,
      points: json['points'] ?? 0,
      players: List<String>.from(json['players'] ?? []),
      starters: List<String>.from(json['starters'] ?? []),
    );
  }
}