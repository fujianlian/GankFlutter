import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/gank/CommonComponent.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:flutter_gank/models/PageList.dart';
import 'package:flutter_gank/net/api_gank.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FuliPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FuliPageState();
  }
}

class FuliPageState extends State<FuliPage> with AutomaticKeepAliveClientMixin {
  List<GankInfo> _data = List();
  var _currentIndex = 1;
  var _crossAxisCount = 2;

  /// 是否正加载万所有数据
  var _loadFinish = false;

  /// 是否正在加载数据
  bool isLoading = false;

  RefreshController _refreshController =
    RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _pullNet();
  }

  void _onRefresh() async {
    _loadFinish = false;
    _currentIndex = 1;
    _refreshController.resetNoData();
    _pullNet();
  }

  void _onLoading() async {
    if (_loadFinish) {
      _refreshController.loadNoData();
    } else {
      _currentIndex += 1;
      _pullNet();
    }
  }

  void _pullNet() {
    GankApi.getGirlList(10, _currentIndex).then((PageList list) {
      if (_currentIndex == 1) {
        _data.clear();
        _refreshController.refreshCompleted();
      } else {
        _refreshController.loadComplete();
      }
      isLoading = false;
      if (list.results.length<10) {
        setState(() {
          _data.addAll(list.results);
          _loadFinish = true;
        });
        _refreshController.loadNoData();
      } else {
        setState(() {
          _data.addAll(list.results);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('妹纸'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.transform),
            onPressed: () {
              setState(() {
                if (_crossAxisCount == 2)
                  _crossAxisCount = 1;
                else
                  _crossAxisCount = 2;
              });
            },
          )
        ],
      ),
      body: _data.isEmpty
          ? LoadingWidget()
          : _buildListView(),
    );
  }

  Widget _buildListView() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("上拉刷新");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("加载失败！点击重试！");
          } else {
            body = Text("没有更多数据了。。。");
          }
          return Container(
            height: 48.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: GridView.builder(
              padding: EdgeInsets.all(5.0),
              itemBuilder: _renderRow,
              itemCount: _data.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount,
                childAspectRatio: _crossAxisCount == 1 ? 1 : 0.8,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              ),
            ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    return _PhotoItem(info: _data[index]);
  }

  /// 加载更多时显示的组件,给用户提示
  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _PhotoItem extends StatelessWidget {
  _PhotoItem({Key key, this.info}) : super(key: key);

  final GankInfo info;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new GestureDetector(
          onTap: () {
            _showPhoto(context);
          },
          child: Hero(
              tag: info.url,
              child: new CachedNetworkImage(
                fit: BoxFit.cover,
                placeholder: (context, url) => new Image(
                  image: AssetImage("images/fuli.png"),
                  fit: BoxFit.cover,
                ),
                imageUrl: info.url,
              ))),
    );
  }

  _showPhoto(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(info.desc),
          centerTitle: true,
        ),
        body: Center(
          child: Hero(
              tag: info.url,
              child: new CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl: info.url,
              )),
        ),
      );
    }));
  }
}
