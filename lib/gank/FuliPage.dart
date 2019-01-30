import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/gank/CommonComponent.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:flutter_gank/models/PageList.dart';
import 'package:flutter_gank/net/api_gank.dart';

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

  /// listView的控制器
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pullNet();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_loadFinish) _getMore();
      }
    });
  }

  void _pullNet() {
    GankApi.getListData("福利", 20, _currentIndex).then((PageList list) {
      isLoading = false;
      setState(() {
        if (list.results.isEmpty) {
          _loadFinish = true;
        } else {
          _data.addAll(list.results);
        }
      });
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
          : Container(
              child: GridView.builder(
              padding: EdgeInsets.all(5.0),
              itemBuilder: _renderRow,
              itemCount: _loadFinish ? _data.length : _data.length + 1,
              controller: _scrollController,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount,
                childAspectRatio: _crossAxisCount == 1 ? 1 : 0.8,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
              ),
            )),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < _data.length) {
      return _PhotoItem(info: _data[index]);
    }
    return _getMoreWidget();
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

  /// 上拉加载更多
  _getMore() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      _currentIndex++;
      _pullNet();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
                placeholder: Image(
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
