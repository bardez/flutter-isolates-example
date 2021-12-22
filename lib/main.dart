import 'package:flutter/material.dart';

import 'package:isolate_example/performance_app.dart';
import 'package:isolate_example/thread_page.dart';

void main() {
  runApp(const MaterialApp(home: ThreadApp()));
}

class ThreadApp extends StatelessWidget {
  const ThreadApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thread App'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            OutlinedButton(
              child: const Text('Exemplo de sendPort e ReceivePort'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ThreadPage(),
                  ),
                );
              },
            ),
            OutlinedButton(
              child: const Text('Exemplo performance com Compute'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PerformancePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
