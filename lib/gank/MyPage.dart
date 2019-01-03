import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MyPageState();
  }
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.transform),
            onPressed: () {
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}
