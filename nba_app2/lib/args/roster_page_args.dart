import 'package:equatable/equatable.dart';

class RosterPageArguments extends Equatable {
  final String leagueId;
  final String userId;

  const RosterPageArguments({
    required this.leagueId,
    required this.userId,
  });

  @override
  List<Object?> get props => [leagueId, userId];
}
