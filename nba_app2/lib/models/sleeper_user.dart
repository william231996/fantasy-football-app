class SleeperUser {
  final String username;
  final String user_id;
  final String display_name;

  SleeperUser({
    required this.username,
    required this.user_id,
    required this.display_name,
  });

  factory SleeperUser.fromJson(Map<String, dynamic> json) {
    return SleeperUser(
      username: json['username'] ?? 'username',
      user_id: json['user_id'] ?? 'id',
      display_name: json['display_name'] ?? 'name',
    );
  }
}