class SleeperRoster {
  final int roster_id;
  final List<String> starters;
  final List<String> players;
  final String? owner_id;
  SleeperRoster({
    required this.roster_id,
    required this.starters,
    required this.players,
    required this.owner_id,
  });
  factory SleeperRoster.fromJson(Map<String, dynamic> json) {
    return SleeperRoster(
      roster_id: json['roster_id'] ?? 0,
      starters: List<String>.from(json['starters'] ?? []),
      players: List<String>.from(json['players'] ?? []),
      owner_id: json['owner_id']?.toString(),
    );
  }
}