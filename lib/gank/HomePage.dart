import 'package:banner/banner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/colors.dart';
import 'package:flutter_gank/gank/CommonComponent.dart';
import 'package:flutter_gank/gank/HistoryListPage.dart';
import 'package:flutter_gank/gank/WebPage.dart';
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
  List<Sliders> qqMusic = [];
  double width = 0;

  @override
  void initState() {
    super.initState();
    _pullNet();
  }

  @override
  Widget build(BuildContext context) {
    contexts = context;
    width = MediaQuery.of(context).size.width;
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
    var top = new BannerView(
      data: qqMusic,
      height: width / 5 * 2,
      buildShowView: (index, data) {
        print(data);
        return new BannerItemFactory(music: data);
      },
      onBannerClickListener: (index, data) {
        Navigator.push(contexts == null ? context : contexts,
            new MaterialPageRoute(builder: (context) {
          return new WebPage(url: qqMusic[index].linkUrl, title: "qq音乐");
        }));
      },
    );
    l.add(top);
    _dailyInfo.category.remove("福利");
    _dailyInfo.category.forEach((f) => {
          l.addAll(_addCategory(GankInfo.fromJson(
              _dailyInfo.results[f][_dailyInfo.results[f].length - 1])))
        });
    return l;
  }

  List<Widget> _addCategory(GankInfo info) {
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

  void _pullNet() async {
    await GankApi.getToday().then((DailyInfo info) {
      _dailyInfo = info;
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
    QQMusicApi.getQQBanner().then((QQMusic info) {
      setState(() {
        isLoading = false;
        qqMusic = info.data.slider;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class BannerItemFactory extends StatelessWidget {
  BannerItemFactory({Key key, this.music}) : super(key: key);

  final Sliders music;

  @override
  Widget build(BuildContext context) {
    return new CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: music.picUrl,
    );
  }
}
