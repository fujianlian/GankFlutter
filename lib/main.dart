import 'package:flutter/material.dart';
import 'package:flutter_gank/colors.dart';
import 'gank/MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FlutterGank",
      theme: ThemeData(
        primarySwatch: mainColor,
        scaffoldBackgroundColor: Color(0xFFF7F7F7),
      ),
      home: MainPage(),
    );
  }
}