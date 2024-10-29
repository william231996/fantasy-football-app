import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/sleeper_user.dart';
import 'package:nba_app2/services/user_service.dart';

// if state is the data that detertmines our apps UI, then state management  
// is how we organize our app to most effectively access state and share it across widgets

final userDataProvider = FutureProvider.family<SleeperUser, String>((ref, username) async {
  return ref.watch(userProvider).getSleeperUser(username);
});

// final userDataProvider = FutureProvider<SleeperUser>((ref) async {
//   return ref.watch(userProvider).getSleeperUser('kevin');
// });