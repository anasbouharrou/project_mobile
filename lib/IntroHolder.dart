import 'package:flutter/material.dart';

class Introholder extends StatelessWidget {
  final Widget child;

  Introholder({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(247, 246, 238, 1),
        body: child,
      ),
    );
  }
}
