class SeasonDetails {
  final int week;
  final String season;
  final int display_week;
  SeasonDetails({
    required this.week,
    required this.season,
    required this.display_week,
  });
    factory SeasonDetails.fromJson(Map<String, dynamic> json) {
    return SeasonDetails(
      week: json['week'] ?? 0,
      season: json['season'] ?? '',
      display_week: json['display_week'] ?? 0,
    );
  }
}