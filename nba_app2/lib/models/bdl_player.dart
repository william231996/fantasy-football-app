class BdlPlayer {
  final int id;
  final String first_name;
  final String last_name;
  final String height;
  final String weight;
  final String position;
  final String jersey_number;
  final String college;
  final String country;
  BdlPlayer({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.height,
    required this.weight,
    required this.position,
    required this.jersey_number,
    required this.college,
    required this.country,
  });
  factory BdlPlayer.fromJson(Map<String, dynamic> json) {
    return BdlPlayer(
      id: json['id'] ?? 0,
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      position: json['position'] ?? '',
      jersey_number: json['jersey_number'] ?? '',
      college: json['college'] ?? '',
      country: json['country'] ?? '',
    );
  }
    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'height': height,
      'weight': weight,
      'position': position,
      'jersey_number': jersey_number,
      'college': college,
      'country': country,
    };
  }
    factory BdlPlayer.fromMap(Map<String, dynamic> map) {
    return BdlPlayer(
      id: map['id'] ?? 0,
      first_name: map['first_name'] ?? '',
      last_name: map['last_name'] ?? '',
      height: map['height'] ?? '',
      weight: map['weight'] ?? '',
      position: map['position'] ?? '',
      jersey_number: map['jersey_number'] ?? '',
      college: map['college'] ?? '',
      country: map['country'] ?? '',
    );
  }
  
}