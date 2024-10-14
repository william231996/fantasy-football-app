import 'dart:convert';
import 'dart:io';

import 'package:chico_ff/appbars/matchup_appbar.dart';
import 'package:chico_ff/appbars/players_appbar.dart';
import 'package:chico_ff/models/teams_model.dart';
import 'package:chico_ff/widgets/matchup_card.dart';
import 'package:chico_ff/widgets/player_card.dart';
import 'package:chico_ff/appbars/home_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Team> teams = []; // stores the list of teams

  // retrieve Team Info data from API
  Future getTeams() async {

    // API call
    var response = await http.get(
      Uri.https('api.balldontlie.io', 'v1/teams'),
      headers: {HttpHeaders.authorizationHeader: '48ecfd27-3b32-46c9-b02e-e0c5f02ab895'},
    );

    var jsonData = jsonDecode(response.body); // store and convert json data to readable format
    
    // loop to retrieve specified data from response
    for (var eachTeam in jsonData['data']) { 
      final team = Team(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
      );
      teams.add(team); // add team to teams list
    }
  }

  // access 
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder (
          stream: _firebaseFirestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Home_Appbar(snapshot.data!.docs[0].data());
          }
        ),
        backgroundColor: Colors.blue,
      ),


      body: FutureBuilder(
        future: getTeams(),
        builder: (context, snapshot) {
          // if API connection is done loading
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: 30, //teams.length, // itemCount sets the number of teams displayed
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(teams[index].abbreviation),
                      subtitle: Text(teams[index].city),
                    ),
                  ),
                );
              }
            );
          }
          // if API connection is still loading
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}



// class _HomeScreenState extends State<HomeScreen> {
//   List<Team> teams = []; // stores the list of teams

//   // retrieve Team Info data from API
//   Future getTeams() async {

//     // API call
//     var response = await http.get(
//       Uri.https('api.balldontlie.io', 'v1/teams'),
//       headers: {HttpHeaders.authorizationHeader: '48ecfd27-3b32-46c9-b02e-e0c5f02ab895'},
//     );

//     var jsonData = jsonDecode(response.body); // store and convert json data to readable format
    
//     // loop to retrieve specified data from response
//     for (var eachTeam in jsonData['data']) { 
//       final team = Team(
//         abbreviation: eachTeam['abbreviation'],
//         city: eachTeam['city'],
//       );
//       teams.add(team); // add team to teams list
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: getTeams(),
//         builder: (context, snapshot) {
//           // if API connection is done loading
//           if (snapshot.connectionState == ConnectionState.done) {
//             return ListView.builder(
//               itemCount: 30, //teams.length, // itemCount sets the number of teams displayed
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       title: Text(teams[index].abbreviation),
//                       subtitle: Text(teams[index].city),
//                     ),
//                   ),
//                 );
//               }
//             );
//           }
//           // if API connection is still loading
//           else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         }
//       ),
//     );
//   }
// }