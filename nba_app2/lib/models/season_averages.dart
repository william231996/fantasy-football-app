class SeasonAverage {
  final int player_id;
  final int season;
  final double pts;
  final double reb;
  final double ast;
  final double stl;
  final double blk;
  final double fg_pct;
  final double fg3_pct;
  final double ft_pct;
  final int games_played;
  final String min;
  SeasonAverage({
    required this.player_id,
    required this.season,
    required this.pts,
    required this.reb,
    required this.ast,
    required this.stl,
    required this.blk,
    required this.fg_pct,
    required this.fg3_pct,
    required this.ft_pct,
    required this.games_played,
    required this.min,
  });
factory SeasonAverage.fromJson(Map<String, dynamic> json) {
  return SeasonAverage(
    player_id: json['player_id'] ?? 0,
    season: json['season'] ?? 0,
    pts: (json['pts'] ?? 0).toDouble(),
    reb: (json['reb'] ?? 0).toDouble(),
    ast: (json['ast'] ?? 0).toDouble(),
    stl: (json['stl'] ?? 0).toDouble(),
    blk: (json['blk'] ?? 0).toDouble(),
    fg_pct: (json['fg_pct'] ?? 0).toDouble(),
    fg3_pct: (json['fg3_pct'] ?? 0).toDouble(),
    ft_pct: (json['ft_pct'] ?? 0).toDouble(),
    games_played: json['games_played'] ?? 0,
    min: json['min'] ?? '',
  );
}
factory SeasonAverage.fromMap(Map<String, dynamic> map) {
  return SeasonAverage(
    player_id: map['player_id'],
    season: map['season'],
    pts: (map['pts'] as num).toDouble(),
    reb: (map['reb'] as num).toDouble(),
    ast: (map['ast'] as num).toDouble(),
    stl: (map['stl'] as num).toDouble(),
    blk: (map['blk'] as num).toDouble(),
    fg_pct: (map['fg_pct'] as num).toDouble(),
    fg3_pct: (map['fg3_pct'] as num).toDouble(),
    ft_pct: (map['ft_pct'] as num).toDouble(),
    games_played: map['games_played'],
    min: map['min'],
  );
}
  Map<String, dynamic> toMap() {
    return {
      'player_id': player_id,
      'season': season,
      'pts': pts,
      'reb': reb,
      'ast': ast,
      'stl': stl,
      'blk': blk,
      'fg_pct': fg_pct,
      'fg3_pct': fg3_pct,
      'ft_pct': ft_pct,
      'games_played': games_played,
      'min': min,
    };
  }
}
