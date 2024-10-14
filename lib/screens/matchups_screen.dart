import 'package:chico_ff/appbars/matchup_appbar.dart';
import 'package:chico_ff/widgets/matchup_card.dart';
import 'package:flutter/material.dart';

class MatchupScreen extends StatefulWidget {
  const MatchupScreen({super.key});

  @override
  State<MatchupScreen> createState() => _MatchupScreenState();
}

class _MatchupScreenState extends State<MatchupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 36),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 160,
              flexibleSpace: FlexibleSpaceBar(
                title: Matchup_Appbar(),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return MatchupCard();
                },
                childCount: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

