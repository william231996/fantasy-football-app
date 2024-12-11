import 'package:nba_app2/models/bdl_player.dart';

class Leader {
  final BdlPlayer player; // Use BdlPlayer here
  final double value;
  final String stat_type;
  final int rank;
  final int season;
  final int games_played;

  Leader({
    required this.player,
    required this.value,
    required this.stat_type,
    required this.rank,
    required this.season,
    required this.games_played,
  });

  factory Leader.fromJson(Map<String, dynamic> json) {
    return Leader(
      player: BdlPlayer.fromJson(json['player']),
      value: (json['value'] ?? 0.0).toDouble(),
      stat_type: json['stat_type'] ?? '',
      rank: json['rank'] ?? 0,
      season: json['season'] ?? 0,
      games_played: json['games_played'] ?? 0,
    );
  }
}

class LeadersResponse {
  final List<Leader> data;

  LeadersResponse({required this.data});

  factory LeadersResponse.fromJson(Map<String, dynamic> json) {
    return LeadersResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => Leader.fromJson(item))
          .toList(),
    );
  }
}