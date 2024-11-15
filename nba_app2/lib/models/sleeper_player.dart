class SleeperPlayer {
  final String player_id;
  final String first_name;
  final String last_name;
  final String team;
  final int? number;
  SleeperPlayer({
    required this.player_id,
    required this.first_name,
    required this.last_name,
    required this.team,
    required this.number,
  });
  factory SleeperPlayer.fromJson(Map<String, dynamic> json) {
    return SleeperPlayer(
      player_id: json['player_id'] ?? '',
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      team: json['team'] ?? '',
      number: json['number'] != null
          ? int.tryParse(json['number'].toString())
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'player_id': player_id,
      'first_name': first_name,
      'last_name': last_name,
      'team': team,
      'number': number,
    };
  }
}
