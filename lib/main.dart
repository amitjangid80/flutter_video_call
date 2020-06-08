import 'package:flutter/material.dart';
import 'package:flutter_video_call/src/pages/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Video Call',
      home: IndexPage(),
      theme: ThemeData(primarySwatch: Colors.blue, buttonTheme: ButtonThemeData(height: 50)),
    );
  }
}
