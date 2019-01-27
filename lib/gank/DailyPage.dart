import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/gank/CommonComponent.dart';
import 'package:flutter_gank/gank/GridPhotoViewer.dart';
import 'package:flutter_gank/models/DailyInfo.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:http/http.dart' as http;

class DailyPage extends StatefulWidget {
  DailyPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return new DailyPageState();
  }
}

class DailyPageState extends State<DailyPage> {
  bool isLoading;
  DailyInfo _dailyInfo;
  BuildContext contexts;

  @override
  void initState() {
    super.initState();
    _pullNet();
  }

  @override
  Widget build(BuildContext context) {
    contexts = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: _dailyInfo == null
          ? LoadingWidget()
          : ListView(children: _showAllList()),
    );
  }

  List<Widget> _showAllList() {
    var l = List<Widget>();
    var top = new Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: new GestureDetector(
            onTap: () {
              showPhoto(contexts, _dailyInfo.results.fuli[0]);
            },
            child: new CachedNetworkImage(
              placeholder: Image(
                image: AssetImage("images/fuli.png"),
                fit: BoxFit.cover,
                height: 190.0,
              ),
              fit: BoxFit.cover,
              imageUrl: _dailyInfo.results.fuli == null ||
                      _dailyInfo.results.fuli.isEmpty
                  ? ""
                  : _dailyInfo.results.fuli[0].url,
              height: 190.0,
            )));
    l.add(top);
    if (_dailyInfo.results.android != null)
      l.addAll(_showList("Android", _dailyInfo.results.android));
    if (_dailyInfo.results.iOS != null)
      l.addAll(_showList("iOS", _dailyInfo.results.iOS));
    if (_dailyInfo.results.video != null)
      l.addAll(_showList("休息视频", _dailyInfo.results.video));
    if (_dailyInfo.results.resource != null)
      l.addAll(_showList("拓展资源", _dailyInfo.results.resource));
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
    var url = "http://gank.io/api/day/${widget.title.replaceAll("-", "/")}";
    await http.Client().get(url).then((http.Response response) {
      isLoading = false;
      setState(() {
        _dailyInfo = DailyInfo.fromJson(json.decode(response.body));
      });
    });
  }
}
