import 'package:flutter/material.dart';

class Players_Appbar extends StatelessWidget {
  const Players_Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    leading: CircleAvatar(
      backgroundImage: NetworkImage('https://unsplash.com/photos/a-young-man-with-freckled-hair-wearing-a-beanie-HsBCb94pt7k'),
    ),
    title: Text('User Name'),
    subtitle: Text('Available Players'),
  );
  }
}