import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nba_app2/models/sleeper_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<SleeperUser> getSleeperUser(String username) async {
    var response = await http.get(
      Uri.https('api.sleeper.app', '/v1/user/$username'),
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return SleeperUser.fromJson(result);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final userProvider = Provider<UserService>(
    (ref) => UserService()); // entry point of shared data, shared state