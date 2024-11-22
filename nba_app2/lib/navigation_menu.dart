import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/pages/matchup_page.dart';
import 'package:nba_app2/pages/roster_page.dart';
import 'package:nba_app2/league_info.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class NavigationMenu extends StatelessWidget {
  final String leagueId;
  final String userId;

  NavigationMenu({super.key, required this.leagueId, required this.userId});

  @override
  Widget build(BuildContext context) {
    // WidgetRef ref allows you to interact with the provider
    print("Whole Page Built");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Menu'),
        backgroundColor: Colors.green,
        elevation: 0.0,
      ),
      body: Consumer(
          // whenever the provider gets updated, this widget (Consumer) will rebuild
          builder: (context, ref, child) {
        print('Index Stack Built');
        final currentIndex = ref.watch(
            bottomNavIndexProvider); // By using ref.watch, this widget will rebuild whenever the provider updates


        return IndexedStack(
          index: currentIndex,
          children: [
            RosterPage(leagueId: leagueId, userId: userId),
            MatchupPage(leagueId: leagueId, userId: userId),
            LeagueInfo(),
          ],
        );
      }),
      // whenever the provider gets updated, this widget (Consumer) will rebuild
      bottomNavigationBar: Consumer(builder: (context, ref, child) {
        print('Bottom Nav Built');
        final currentIndex = ref.watch(
            bottomNavIndexProvider); // By using ref.watch, this widget will rebuild whenever the provider updates
        return NavigationBar(
          selectedIndex: currentIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Roster',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Matchups',
            ),
            NavigationDestination(
              icon: Icon(Icons.sports_basketball),
              label: 'League Info',
            ),
          ],
          onDestinationSelected: (value) {
            ref
                .read(bottomNavIndexProvider.notifier)
                .update((state) => value); // .read is used to read the provider
          },
        );
      }),
    );
  }
}
