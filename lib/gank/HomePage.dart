import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/colors.dart';
import 'package:flutter_gank/gank/CommonComponent.dart';
import 'package:flutter_gank/gank/HistoryListPage.dart';
import 'package:flutter_gank/models/DailyInfo.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:flutter_gank/models/QQMusic.dart';
import 'package:flutter_gank/net/api_gank.dart';
import 'package:flutter_gank/net/api_qq_music.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<HomePage> with AutomaticKeepAliveClientMixin {
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
        title: Text('最新'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.reorder),
            onPressed: () {
              setState(() {
                Navigator.push(contexts == null ? context : contexts,
                    new MaterialPageRoute(builder: (context) {
                  return new HistoryListPage();
                }));
              });
            },
          )
        ],
      ),
      body: _dailyInfo == null
          ? LoadingWidget()
          : ListView(children: _showAllList()),
    );
  }

  List<Widget> _showAllList() {
    var l = List<Widget>();
    var top = new Container(
      child: new GestureDetector(
        onTap: () {
          showPhoto(contexts, GankInfo.fromJson(_dailyInfo.results["福利"][0]));
        },
        child: Hero(
            tag: GankInfo.fromJson(_dailyInfo.results["福利"][0]).desc,
            child: new CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: _dailyInfo.results["福利"] == null ||
                      _dailyInfo.results["福利"].isEmpty
                  ? ""
                  : GankInfo.fromJson(_dailyInfo.results["福利"][0]).url,
              height: 190.0,
            )),
      ),
    );
    l.add(top);
    _dailyInfo.category.remove("福利");
    _dailyInfo.category.forEach((f) => {
          l.addAll(_showList(GankInfo.fromJson(
              _dailyInfo.results[f][_dailyInfo.results[f].length - 1])))
        });
    return l;
  }

  List<Widget> _showList(GankInfo info) {
    var l = List<Widget>();
    l.add(HomeListWidget(info: info, contexts: contexts));
    if (info.type != _dailyInfo.category[_dailyInfo.category.length - 1])
      l.add(Divider(height: 0.5, color: c9));
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
          body: Center(
              child: Hero(
            tag: photo.desc,
            child: new CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: photo.url,
            ),
          )));
    }));
  }

  void _pullNet() {
    GankApi.getToday().then((DailyInfo info) {
      setState(() {
        isLoading = false;
        _dailyInfo = info;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });

    QQMusicApi.getQQBanner().then((QQMusic info) {
      isLoading = false;
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}
