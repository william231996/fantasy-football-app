// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:nba_app2/models/team.dart';

// class TestTeamPage extends StatelessWidget {
//   TestTeamPage({super.key});
//   List<Team> teams = [];

//   Future getTeams() async {
//     var response = await http.get(
//       Uri.https('api.balldontlie.io', '/v1/teams'),
//       // Send authorization headers to the backend.
//       headers: {
//         HttpHeaders.authorizationHeader: '${dotenv.env['API_KEY']}',
//       },
//     );

//     print(response.body);

//     if (response.statusCode == 200) {
//       var jsonData = jsonDecode(response.body);
//       for (var eachTeam in jsonData['data']) {
//         final team = Team(
//           id: eachTeam['id'],
//           abbreviation: eachTeam['abbreviation'],
//           city: eachTeam['city'],
//           full_name: eachTeam['full_name'],
//         );
//         teams.add(team);
//       }
//     } else {
//       print('Failed to load teams. Status code: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     getTeams();
//     return Scaffold(
//       body: SafeArea(
//         child: FutureBuilder(
//           future: getTeams(),
//           builder: ((context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return ListView.builder(
//                 itemCount: 30,
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
//                         title: Text('${teams[index].id} ${teams[index].city}'),
//                         subtitle: Text(teams[index].abbreviation),
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
