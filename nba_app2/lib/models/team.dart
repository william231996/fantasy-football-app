class Team {
  final int id;
  final String conference;
  final String division;
  final String full_name;
  final String abbreviation;
  Team({
    required this.id,
    required this.conference,
    required this.division,
    required this.full_name,
    required this.abbreviation,
  });
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      conference: json['conference'] ?? '',
      division: json['division'] ?? '',
      full_name: json['full_name'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
    );
  }
}
