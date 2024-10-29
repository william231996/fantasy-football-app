class SleeperRoster {
  final int roster_id;
  final List<String> starters;
  final List<String> players;
  final String owner_id;
  final String league_id;
  SleeperRoster({
    required this.roster_id,
    required this.starters,
    required this.players,
    required this.owner_id,
    required this.league_id,
  });
}