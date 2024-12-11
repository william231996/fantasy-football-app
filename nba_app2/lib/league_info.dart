import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/pages/box_scores.dart';
import 'package:nba_app2/pages/league_leaders.dart';
import 'package:nba_app2/pages/standings.dart';

final segmnetProvider = StateProvider<int>((ref) => 0);

class LeagueInfo extends ConsumerWidget {
  const LeagueInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSegment = ref.watch(segmnetProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('League Info'),
        backgroundColor: Colors.green,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          // Segmented Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ToggleButtons(
              isSelected: List.generate(
                  3, (index) => index == selectedSegment), // Dynamic selection
              borderRadius: BorderRadius.circular(8.0),
              selectedColor: Colors.white,
              fillColor: Colors.green,
              color: Colors.green,
              splashColor: Colors.greenAccent,
              onPressed: (int index) {
                // Update the selected segment using Riverpod
                ref.read(segmnetProvider.notifier).state = index;
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Box Scores'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Standings'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Statistics'),
                ),
              ],
            ),
          ),
          // Dynamic Content Based on Selected Segment
          Expanded(
            child: _buildContent(selectedSegment),
          ),
        ],
      ),
    );
  }
}

Widget _buildContent(int selectedSegment) {
  switch (selectedSegment) {
    case 0:
      return BoxScoresPage();
    // const Center(
    //   child: Icon(
    //     Icons.bike_scooter,
    //     size: 100,
    //   ),
    // );
    case 1:
      return StandingsPage();
    // return const Center(
    //   child: Icon(
    //     Icons.home_repair_service,
    //     size: 100,
    //   ),
    // );
    case 2:
      return LeagueLeadersPage();
    // return const Center(
    //   child: Icon(
    //     Icons.catching_pokemon,
    //     size: 100,
    //   ),
    // );
    default:
      return const Center(child: Text('Select a segment'));
  }
}
