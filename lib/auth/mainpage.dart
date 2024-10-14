import 'package:chico_ff/auth/auth_page.dart';
import 'package:chico_ff/widgets/navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Navigation_Screen();
          } else {
            return const AuthPage();
          }
        }
      )
    );
  }
}

