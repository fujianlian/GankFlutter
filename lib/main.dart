import 'package:flutter/material.dart';
import 'package:flutter_gank/store/index.dart';
import 'gank/MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Store.init(child: MainPage()),
    );
  }
}