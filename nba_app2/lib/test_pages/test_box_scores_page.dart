import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app2/models/box_scores.dart';
import 'package:nba_app2/models/team.dart';

class TestBoxScoresPage extends StatelessWidget {
  TestBoxScoresPage({super.key});
  List<BoxScore> games = [];
  List<Team> homeTeamList = [];
  List<Team> visitingTeamList = [];

  Future getBoxScore() async {
    final response = await http.get(
      Uri.https('api.balldontlie.io', '/v1/box_scores', {'date': '2023-12-26'}),
      headers: {
        HttpHeaders.authorizationHeader: '${dotenv.env['API_KEY']}',
      },
    );

    print(response.body);

    var jsonData = jsonDecode(response.body);
    for (var eachGame in jsonData['data']) {
      final boxScore = BoxScore(
        date: eachGame['date'],
        home_team_score: eachGame['home_team_score'],
        visitor_team_score: eachGame['visitor_team_score'],
      );
      // retrive home team info from inside box score json data
      var homeTeamData = eachGame['home_team'];
      final homeTeam = Team(
        id: homeTeamData['id'],
        abbreviation: homeTeamData['abbreviation'],
        city: homeTeamData['city'],
        full_name: homeTeamData['full_name'],
      );

      var visitingTeamData = eachGame['visitor_team'];
      final visitingTeam = Team(
        id: visitingTeamData['id'],
        abbreviation: visitingTeamData['abbreviation'],
        city: visitingTeamData['city'],
        full_name: visitingTeamData['full_name'],
      );
      games.add(boxScore);
      homeTeamList.add(homeTeam);
      visitingTeamList.add(visitingTeam);
    }
  }

  @override
  Widget build(BuildContext context) {
    getBoxScore();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getBoxScore(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: games.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(games[index].date),
                        subtitle: Text(
                            '${homeTeamList[index].full_name} ${games[index].home_team_score} ${visitingTeamList[index].full_name} ${games[index].visitor_team_score}'),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    );
  }
}
