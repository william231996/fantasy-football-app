import 'package:flutter/material.dart';
import 'package:nba_app2/args/roster_page_args.dart';
import 'package:nba_app2/navigation_menu.dart';
import 'package:nba_app2/pages/home_page.dart';
import 'package:nba_app2/pages/matchup_page.dart';
import 'package:nba_app2/pages/roster_page.dart';
import 'package:nba_app2/pages/leagues_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/team':
        // Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => LeaguesPage(
              username: args,
            ),
          );
        }
        return _errorRoute(); // If args is not of the correct type, return an error page.
      case '/roster':
        if (args is RosterPageArguments) {
          return MaterialPageRoute(
            builder: (_) => NavigationMenu(
              leagueId: args.leagueId,
              userId: args.userId,
            ),
          );
        }
        return _errorRoute(); // If args is not of the correct type, return an error page.
      case '/matchup':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => MatchupPage(
              leagueId: args,
              userId: args,
            ),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute(); // If there is no such named route in the switch statement, e.g. /third
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
