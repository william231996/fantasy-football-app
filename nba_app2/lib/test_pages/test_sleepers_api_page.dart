
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestSleeperUserPage extends StatelessWidget {
  const TestSleeperUserPage({super.key});

  Future getSleeperUser() async {
    var response = await http.get(
      Uri.https('api.sleeper.app', '/v1/user/1153502918113517568'),
    );

    // print(response.body);

    // if (response.statusCode == 200) {
    //   var jsonData = jsonDecode(response.body);
    //   return SleeperUser(
    //     username: jsonData['username'],
    //     user_id: jsonData['user_id'],
    //     display_name: jsonData['display_name'],
    //     avatar: jsonData['avatar'],
    //   );
    // } else {
    //   print('Failed to load teams. Status code: ${response.statusCode}');
    // }
  }

  @override
  Widget build(BuildContext context) {
    // getSleeperUser();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getSleeperUser(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final user = snapshot.data; // retrieves the user object
              return ListView.builder(
                itemCount: 1,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text('Username: ${user.username} AvatarID: ${user.avatar}'),
                        subtitle: Text('Display Name: ${user.display_name} UserID: ${user.user_id}'),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    );
  }
}
