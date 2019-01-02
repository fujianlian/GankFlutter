import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:http/http.dart' as http;
import 'WebPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<HomePage> {
  List<Results> data;

  @override
  void initState() {
    super.initState();
    _pullNet();
  }

  void _pullNet() async {
    await http
        .get("http://gank.io/api/data/Android/15/1")
        .then((http.Response response) {
      var convertDataToJson = GankInfo.fromJson(json.decode(response.body));
      setState(() {
        data = convertDataToJson.results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        centerTitle: true,
      ),


      body: new ListView(children: data != null ? _getItem() : _loading()),
    );
  }

  List<Widget> _loading() {
    return <Widget>[
      new Container(
        height: 300.0,
        child: new Center(
            child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularProgressIndicator(
              strokeWidth: 1.0,
            ),
            new Text("正在加载"),
          ],
        )),
      )
    ];
  }

  List<Widget> _getItem() {
    return data.map((item) {
      return new GestureDetector(
          onTap: () {
            //导航到新路由
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return new WebPage(url: item.url,title: item.desc);
            }));
          },
          child: new Card(
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: _getRowWidget(item),
            ),
            elevation: 3.0,
            margin: const EdgeInsets.only(
                left: 10.0, top: 6.0, right: 10.0, bottom: 6.0),
          ));
    }).toList();
  }

  Widget _getRowWidget(item) {
    return new Row(
      children: <Widget>[
        new Flexible(
            flex: 1,
            fit: FlexFit.tight, //和android的weight=1效果一样
            child: new Stack(
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Text("${item.desc}",
                        maxLines: 3,
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.start),
                    new Row(children: <Widget>[
                      new Text(
                        "${item.who}",
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 14.0,
                        ),
                      ),
                      new Text(
                        "${item.createdAt}".substring(0, 10),
                        style: new TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.right,
                      )
                    ])
                  ],
                )
              ],
            )),
      ],
    );
  }
}
