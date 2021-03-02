import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/gank/CommonComponent.dart';
import 'package:flutter_gank/gank/WebPage.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:flutter_gank/models/banner_list.dart';
import 'package:flutter_gank/net/gank/api.dart';
import 'package:flutter_gank/net/gank/apiService.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
      ),
      body: list.isEmpty
          ? LoadingWidget()
          : ListView.builder(
              itemBuilder: _renderRow, itemCount: list.length + 1),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index == 0) return _top();
    return HomeListWidget(info: list[index - 1], contexts: contexts);
  }

  Widget _top() {
    return banners.isEmpty
        ? Container()
        : Container(
            height: 160,
            child: Swiper(
              onTap: (index) {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return new WebPage(
                    url: banners[index].url,
                    title: banners[index].title,
                  );
                }));
              },
              itemBuilder: (BuildContext context, int index) {
                return CachedNetworkImage(
                  imageUrl: banners[index].image,
                  fit: BoxFit.cover,
                );
              },
              itemCount: banners.length,
              pagination: new SwiperPagination(),
            ),
          );
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
    await request({}, APIService.getHot).then((res) {
      for (int i = 0; i < res.data.length; i++) {
        list.add(GankInfo.fromJson(res.data[i]));
      }
      isLoading = false;
    });
    await request({}, APIService.getBanners).then((res) {
      for (int i = 0; i < res.data.length; i++) {
        banners.add(BannerInfo.fromJson(res.data[i]));
      }

      setState(() {
        isLoading = false;
      });
    });
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
