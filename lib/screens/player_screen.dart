import 'dart:convert';
import 'dart:io';
import 'package:chico_ff/models/players_model.dart';
import 'package:chico_ff/widgets/player_card.dart';
import 'package:chico_ff/appbars/players_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  
  List<Players> players = []; // create a list of players
  
  // retrieve Player Info data from API
  Future getPlayers() async {
    var response = await http.get(
      Uri.https('api.balldontlie.io', 'v1/players'),
      headers: {HttpHeaders.authorizationHeader: '48ecfd27-3b32-46c9-b02e-e0c5f02ab895'},
    );

    var jsonData = jsonDecode(response.body);
    for (var eachPlayer in jsonData['data']) {
      final player = Players(
        first_name: eachPlayer['first_name'],
        last_name: eachPlayer['last_name'],
        position: eachPlayer['position'],
      );
      players.add(player);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: 24, //players.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(players[index].first_name + ' ' + players[index].last_name), // concatenates first_name and last_name of player in title 
                      subtitle: Text(players[index].position),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}



// class _PlayerScreenState extends State<PlayerScreen> {
//   // retrieve data from firestore
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 36),
//         child: CustomScrollView(
//           slivers: <Widget>[
//             SliverAppBar(
//               pinned: true,
//               floating: true,
//               expandedHeight: 160,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Players_Appbar(),
//               ),
//             ),
//             StreamBuilder(
//               stream: _firebaseFirestore
//                   .collection('QB_Week1_Stats')
//                   .snapshots(), // retrieve collection snapshot from firestore
//               builder: (context, snapshot) {
//                 return SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       return PlayerCard(
//                         snapshot.data!.docs[index].data(),// pass firestore snapshot
//                       ); 
//                     },
//                     childCount: 18,
//                   ),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

