import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app2/models/sleeper_roster.dart';

class RosterPage extends StatelessWidget {
  final String leagueId;
  final String userId;

  RosterPage({super.key, required this.leagueId, required this.userId});
  List<SleeperRoster> rosters = [];

  Future getSleeperRoster() async {
    var response = await http.get(
      Uri.https('api.sleeper.app', '/v1/league/$leagueId/rosters'),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      for (var eachRoster in jsonData) {
        if (eachRoster['owner_id'] == userId) {
          final roster = SleeperRoster(
            roster_id: eachRoster['roster_id'],
            starters: List<String>.from(eachRoster['starters']),
            players: List<String>.from(eachRoster['players']),
            owner_id: eachRoster['owner_id'],
            league_id: eachRoster['league_id'],
          );
          rosters.add(roster);
        }
      }
    } else {
      print('Failed to load teams. Status code: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // getSleeperRoster();
    return FutureBuilder(
      future: getSleeperRoster(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          return Scaffold(
            // appBar: AppBar(
            //   title: const Text('Roster Page'),
            //   backgroundColor: Colors.green,
            //   elevation: 0.0,
            // ), 
            body: SafeArea(
              child: ListView.builder(
                itemCount: rosters.length,
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
                        title: Text(
                            'Roster ID: ${rosters[index].roster_id} OwnerID: ${rosters[index].owner_id}'),
                        subtitle: Text(
                            'Starters: ${rosters[index].starters} Players: ${rosters[index].players}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

