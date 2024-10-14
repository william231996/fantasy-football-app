import 'package:flutter/material.dart';

class Home_Appbar extends StatelessWidget {
  
  final snapshot;
  const Home_Appbar(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    leading: CircleAvatar(
      backgroundImage: NetworkImage('https://unsplash.com/photos/a-young-man-with-freckled-hair-wearing-a-beanie-HsBCb94pt7k'),
    ),
    title: Text(snapshot['username']),
    subtitle: Text('Roster'),
  );
  }
}