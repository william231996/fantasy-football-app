import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app2/models/game.dart';
import 'package:nba_app2/models/player.dart';
import 'package:nba_app2/models/team.dart';
import 'package:nba_app2/models/stats.dart';

class TestStatsPage extends StatelessWidget {
  TestStatsPage({super.key});
  List<Stats> statLine = [];
  List<Player> playerInfo = [];
  List<Team> teamInfo = [];
  List<Game> gameInfo = [];

  Future getStats() async {
    final response = await http.get(
      Uri.https('api.balldontlie.io', '/v1/stats', {
        'player_ids[]': '115',
        'seasons[]': '2023',
      }),
      headers: {
        HttpHeaders.authorizationHeader: '${dotenv.env['API_KEY']}',
      },
    );
    print(response.body);

    var jsonData = jsonDecode(response.body);
    for (var eachStat in jsonData['data']) {
      final stat = Stats(
        id: eachStat['id'],
        min: eachStat['min'],
        reb: eachStat['reb'],
        ast: eachStat['ast'],
        stl: eachStat['stl'],
        blk: eachStat['blk'],
        pts: eachStat['pts'],
      );
      var playerData = eachStat['player'];
      final player = Player(
        id: playerData['id'], 
        first_name: playerData['first_name'], 
        last_name: playerData['last_name'], 
        height: playerData['height'], 
        weight: playerData['weight'], 
        position: playerData['position'],
      );
      var teamData = eachStat['team'];
      final team = Team(
        id: teamData['id'], 
        abbreviation: teamData['abbreviation'], 
        city: teamData['city'], 
        full_name: teamData['full_name'],
      );
      var gameData = eachStat['game'];
      final game = Game(
        id: gameData['id'], 
        date: gameData['date'], 
        season: gameData['season'], 
        home_team_score: gameData['home_team_score'], 
        visitor_team_score: gameData['visitor_team_score'], 
        home_team_id: gameData['home_team_id'], 
        visitor_team_id: gameData['visitor_team_id'],
      );

      statLine.add(stat);
      playerInfo.add(player);
      teamInfo.add(team);
      gameInfo.add(game);
    }
    print(statLine.length);
  }

  @override
  Widget build(BuildContext context) {
    getStats();
    return Scaffold(
            body: SafeArea(
        child: FutureBuilder(
          future: getStats(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: statLine.length,
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
                        title: Text('${teamInfo[index].full_name} ${playerInfo[index].first_name} ${playerInfo[index].last_name}'),
                        subtitle: Text(
                            '${gameInfo[index].date} ${statLine[index].pts} ${statLine[index].reb} ${statLine[index].ast} ${statLine[index].stl} ${statLine[index].blk}'),
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
