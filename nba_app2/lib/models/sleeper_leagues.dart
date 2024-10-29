class SleeperLeagues {
  final String sport;
  final String season;
  final String name;
  final String league_id;
  
  SleeperLeagues({
    required this.sport,
    required this.season,
    required this.name,
    required this.league_id,
  });

  factory SleeperLeagues.fromJson(Map<String, dynamic> json) {
    return SleeperLeagues(
      sport: json['sport'] ?? 'sport',
      season: json['season'] ?? 'season',
      name: json['name'] ?? 'name',
      league_id: json['league_id'] ?? 'league_id',
    );
  }
}
