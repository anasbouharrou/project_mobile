import 'package:flutter/material.dart';
import 'IntroWidgetConstructor.dart';
import 'IntroWidget1.dart';
import 'IntroWidget2.dart';
import 'IntroWidget3.dart';
import 'IntroWidget4.dart';
import 'MainWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(247, 246, 238, 1),
        body: Container(
          child: IntroWidget1(),
        ),
      ),
    );
  }
}
