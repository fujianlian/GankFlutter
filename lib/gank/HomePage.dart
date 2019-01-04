import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/gank/CommonComponent.dart';
import 'package:flutter_gank/gank/GridPhotoViewer.dart';
import 'package:flutter_gank/models/DailyInfo.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<HomePage> {
  bool isLoading;
  DailyInfo _DailyInfo;
  BuildContext contexts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pullNet();
  }

  @override
  Widget build(BuildContext context) {
    contexts = context;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('最新'),
        ),
        body: _DailyInfo == null
            ? LoadingWidget()
            : ListView(children: _showAllList()),
      ),
    );
  }

  List<Widget> _showAllList() {
    var l = List<Widget>();
    var top = new Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: new GestureDetector(
            onTap: () {
              showPhoto(contexts, _DailyInfo.results.fuli[0]);
            },
            child: new CachedNetworkImage(
              placeholder: Image(
                image: AssetImage("images/fuli.png"),
                fit: BoxFit.cover,
                height: 190.0,
              ),
              fit: BoxFit.cover,
              imageUrl: _DailyInfo.results.fuli[0].url,
              height: 190.0,
            )));
    l.add(top);
    l.addAll(_showList("Android", _DailyInfo.results.android));
    l.addAll(_showList("iOS", _DailyInfo.results.iOS));
    l.addAll(_showList("休息视频", _DailyInfo.results.video));
    l.addAll(_showList("拓展资源", _DailyInfo.results.resource));
    return l;
  }

  List<Widget> _showList(String title, List<GankInfo> list) {
    var l = List<Widget>();
    var top = new Container(
        margin: EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            Text(
              title,
              style: new TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ],
        ));
    l.add(top);
    list.forEach((f) => l.add(ShowListWidget(info: f, contexts: contexts)));
    return l;
  }

  void showPhoto(BuildContext context, GankInfo photo) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(photo.desc),
          centerTitle: true,
        ),
        body: SizedBox.expand(
          child: Hero(
            tag: photo.id,
            child: GridPhotoViewer(photo: photo),
          ),
        ),
      );
    }));
  }

  void _pullNet() async {
    var url = "http://gank.io/api/today";
    await http.get(url).then((http.Response response) {
      isLoading = false;
      setState(() {
        _DailyInfo = DailyInfo.fromJson(json.decode(response.body));
      });
    });
  }
}
