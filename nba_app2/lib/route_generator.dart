import 'package:flutter/material.dart';
import 'package:nba_app2/args/roster_page_args.dart';
import 'package:nba_app2/navigation_menu.dart';
import 'package:nba_app2/pages/home_page.dart';
import 'package:nba_app2/pages/roster_page.dart';
import 'package:nba_app2/pages/team_page.dart';

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
            builder: (_) => TeamPage(
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

        // if (args is RosterPageArguments){
        //   return MaterialPageRoute(
        //     builder: (_) => RosterPage(
        //       leagueId: args.leagueId,
        //       userId: args.userId,
        //     ),
        //   );
        // }
        return _errorRoute(); // If args is not of the correct type, return an error page.
      default:
        return _errorRoute();  // If there is no such named route in the switch statement, e.g. /third
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