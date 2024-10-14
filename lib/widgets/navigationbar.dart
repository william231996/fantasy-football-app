import 'package:chico_ff/screens/home_screen.dart';
import 'package:chico_ff/screens/matchups_screen.dart';
import 'package:chico_ff/screens/player_screen.dart';
import 'package:flutter/material.dart';

class Navigation_Screen extends StatefulWidget {
  const Navigation_Screen({super.key});

  @override
  State<Navigation_Screen> createState() => _Navigation_ScreenState();
}

int _currentIndex = 0;

class _Navigation_ScreenState extends State<Navigation_Screen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: navigationTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_football),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: '',
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: const [
          HomeScreen(),
          MatchupScreen(),
          PlayerScreen(),
        ],
      ),
    );
  }
}
