// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:nba_app2/models/team.dart';
// import 'package:nba_app2/models/player.dart';

// class TestSpecificPlayerPage extends StatelessWidget {
//   TestSpecificPlayerPage({super.key});
//   List<Player> players = [];
//   List<Team> teamInfo = [];

//   Future getPlayers() async {
//     var response = await http.get(
//       Uri.https('api.balldontlie.io', '/v1/players/active', {'team_ids[]': '17'}), 
//       // 'search': 'Davis' : returns players with davis in name
//       // 'team_ids[]': '6' : returns players from team with id 6 (Cleveland Cavaliers)
//       headers: {
//         HttpHeaders.authorizationHeader: '${dotenv.env['API_KEY']}',
//       },
//     );

//     print(response.body);
    
//     var jsonData = jsonDecode(response.body);
//     for (var eachPlayer in jsonData['data']) {
//       final player = Player(
//         id: eachPlayer['id'],
//         first_name: eachPlayer['first_name'],
//         last_name: eachPlayer['last_name'],
//         height: eachPlayer['height'],
//         weight: eachPlayer['weight'],
//         position: eachPlayer['position'],
//       );
//       // retrieve team info inside the player object
//       var teamData = eachPlayer['team'];
//       final team = Team(
//         id: teamData['id'],
//         abbreviation: teamData['abbreviation'],
//         city: teamData['city'],
//         full_name: teamData['full_name'],
//       );
//       players.add(player);
//       teamInfo.add(team);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: FutureBuilder(
//           future: getPlayers(),
//           builder: ((context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return ListView.builder(
//                 itemCount: players.length,
//                 padding: const EdgeInsets.all(8),
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.greenAccent,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: ListTile(
//                         title: Text(
//                             '${players[index].id} ${players[index].first_name} ${players[index].last_name}'),
//                         subtitle: Text(
//                             '${players[index].height} ${players[index].weight} ${players[index].position} ${teamInfo[index].city}'),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           }),
//         ),
//       ),
//     );
//   }
// }