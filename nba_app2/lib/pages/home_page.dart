import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  final _textController = TextEditingController(); // Gets user input

  @override
  void dispose() {
    _textController.dispose(); // dispose the controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Enter your username',
                suffixIcon: IconButton(
                  onPressed: () {
                    var username = _textController.text;
                    Navigator.of(context)
                        .pushNamed('/team', arguments: username);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}