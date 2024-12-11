class SleeperPlayer {
  final String player_id;
  final String first_name;
  final String last_name;
  final String team;
  final int? number;
  final int? bdl_player_id;
  SleeperPlayer({
    required this.player_id,
    required this.first_name,
    required this.last_name,
    required this.team,
    required this.number,
    this.bdl_player_id,
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
      bdl_player_id: json['bdl_player_id'] as int?, // retrieve bdl_player_id
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'player_id': player_id,
      'first_name': first_name,
      'last_name': last_name,
      'team': team,
      'number': number,
      'bdl_player_id': bdl_player_id,
    };
  }
}
