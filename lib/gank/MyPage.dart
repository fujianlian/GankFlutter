import 'package:flutter/material.dart';
import 'package:flutter_gank/gank/MarkDownPage.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MyPageState();
  }
}

class _MyPageState extends State<MyPage> {
  static var _color = Color(0xFFFCFCFC);
  static BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        centerTitle: true,
      ),
      body: new Container(
          color: Color(0xFFF0F0F0),
          child: ListView(
            children: list,
          )),
    );
  }

  List<Widget> list = <Widget>[
    new Container(
      color: _color,
      padding: EdgeInsets.only(right: 16.0, top: 5.0, bottom: 5.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new ListTile(
              title: new Text('Github账号登陆',
                  style: new TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20.0)),
              subtitle: new Text(
                "暂未支持，下个版本实现",
                style: new TextStyle(fontSize: 12.0),
              ),
            ),
          ),
          new Image(
            image: AssetImage("images/avatar.png"),
            width: 56,
            height: 56,
          )
        ],
      ),
    ),
    new Container(
      margin: EdgeInsets.only(top: 15.0),
      color: _color,
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text('点个star', style: new TextStyle(fontSize: 18.0)),
            trailing: new Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: () {
              launch("https://github.com/fujianlian/GankFlutter");
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Divider(height: 0.0),
          ),
          new ListTile(
            title: new Text('提Issue/PR', style: new TextStyle(fontSize: 18.0)),
            trailing: new Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: () {
              launch("https://github.com/fujianlian/GankFlutter/issues");
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Divider(height: 0.0),
          ),
          new ListTile(
            title: new Text('关于', style: new TextStyle(fontSize: 18.0)),
            trailing: new Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: () {
              Navigator.push(_context,
                  new MaterialPageRoute(builder: (context) {
                return new MarkDownPage(title: "几点");
              }));
            },
          ),
        ],
      ),
    ),
  ];
}
