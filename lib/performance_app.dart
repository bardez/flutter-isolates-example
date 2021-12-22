import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class PerformancePage extends StatefulWidget {
  const PerformancePage({Key? key}) : super(key: key);

  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  //
  Future<void> computeFuture = Future.value();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance using Isolate'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
              addButton1(),
              addButton2(),
            ],
          ),
        ),
      ),
    );
  }

  addButton1() {
    return FutureBuilder<void>(
      future: computeFuture,
      builder: (context, snapshot) {
        return OutlinedButton(
          child: const Text('Isolate Principal'),
          onPressed: createMainIsolateCallback(context, snapshot),
        );
      },
    );
  }

  addButton2() {
    return FutureBuilder<void>(
      future: computeFuture,
      builder: (context, snapshot) {
        return OutlinedButton(
          child: const Text('Isolate Secundário'),
          onPressed: createSecondaryIsolateCallback(context, snapshot),
        );
      },
    );
  }

  VoidCallback? createMainIsolateCallback(
      BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return () {
        setState(() {
          computeFuture = computeOnMainIsolate().then((val) {
            showSnackBar(context, 'Isolate Principal: $val');
          });
        });
      };
    } else {
      return null;
    }
  }

  VoidCallback? createSecondaryIsolateCallback(
      BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return () {
        setState(() {
          computeFuture = computeOnSecondaryIsolate().then((val) {
            showSnackBar(context, 'Isolate Secundário: $val');
          });
        });
      };
    } else {
      return null;
    }
  }

  Future<int> computeOnMainIsolate() async {
    return await Future.delayed(
        const Duration(milliseconds: 100), () => fib(40));
  }

  Future<int> computeOnSecondaryIsolate() async {
    return await compute(fib, 40);
  }

  showSnackBar(context, message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

int fib(int n) {
  int number1 = n - 1;
  int number2 = n - 2;
  if (0 == n) {
    return 0;
  } else if (1 == n) {
    return 1;
  } else {
    return (fib(number1) + fib(number2));
  }
}
