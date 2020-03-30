import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/gank/CommonComponent.dart';
import 'package:flutter_gank/gank/WebPage.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:flutter_gank/models/HotList.dart';
import 'package:flutter_gank/models/banner_list.dart';
import 'package:flutter_gank/net/api_gank.dart';
import 'package:flutter_gank/widget/gank_banner.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  bool isLoading;
  List<GankInfo> list = [];
  BuildContext contexts;
  List<BannerInfo> banners = [];
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
        title: Text('热门'),
        /* actions: <Widget>[
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
        ], */
      ),
      body: list.isEmpty
          ? LoadingWidget()
          : ListView.builder(
              itemBuilder: _renderRow,
              itemCount: list.length+1
            ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if(index==0)
      return _top();
    return HomeListWidget(info: list[index-1], contexts: contexts);
  }
  
  Widget _top() {
    return Column(
        key: Key('__header__'),
        //physics: AlwaysScrollableScrollPhysics(),
        //padding: EdgeInsets.only(),
        children: _pageSelector(context));
  }

  List<Widget> _pageSelector(BuildContext context) {
    List<Widget> list = [];
    List<BannerInfo> bannerStories = [];
    banners.forEach((item) {
      bannerStories.add(item);
    });
    if (banners.length > 0) {
      list.add(GankBanner(bannerStories, (banner) {
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return new WebPage(url: banner.url, title: banner.title);
        }));
      }));
    }
    return list;
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
    await GankApi.getHot().then((HotList info) {
      list = info.results;
      setState(() {
        list = info.results;
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
    await GankApi.getBanners().then((BannerList info) {
      banners = info.results;
      setState(() {
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
    /* QQMusicApi.getQQBanner().then((QQMusic info) {
      setState(() {
        isLoading = false;
        qqMusic = info.data.slider;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    }); */
  }

  @override
  bool get wantKeepAlive => true;
}