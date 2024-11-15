import 'package:equatable/equatable.dart';

class MatchupArgs extends Equatable {
  final String leagueId;
  final int week;

  MatchupArgs({
    required this.leagueId,
    required this.week,
  });

  @override
  List<Object?> get props => [leagueId, week];
}