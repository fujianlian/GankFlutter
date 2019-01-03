import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:http/http.dart' as http;

import 'GridPhotoViewer.dart';

class FuliPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new FuliPageState();
  }
}

class FuliPageState extends State<FuliPage> with AutomaticKeepAliveClientMixin {
  List<Results> _data = List();
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

  void _pullNet() async {
    var irl = "http://gank.io/api/data/福利/20/$_currentIndex";
    await http.get(irl).then((http.Response response) {
      isLoading = false;
      var convertDataToJson = GankInfo.fromJson(json.decode(response.body));
      setState(() {
        if (convertDataToJson.results.isEmpty) {
          _loadFinish = true;
        } else {
          _data.addAll(convertDataToJson.results);
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
          ? new Container(
              height: window.physicalSize.height,
              child: new Center(
                  child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                  new Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: new Text("正在加载")),
                ],
              )),
            )
          : new Container(
              child: GridView.builder(
              padding: EdgeInsets.all(5.0),
              itemBuilder: _renderRow,
              itemCount: _loadFinish ? _data.length : _data.length + 1,
              controller: _scrollController,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _crossAxisCount,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0),
            )),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < _data.length) {
      return _getItem(_data[index]);
    }
    return _getMoreWidget();
  }

  Widget _getItem(Results item) {
    return new Container(
      child: new GestureDetector(
          onTap: () {
            showPhoto(context, item);
          },
          child: new CachedNetworkImage(
            fit: BoxFit.cover,
            placeholder: Image(
              image: AssetImage("images/fuli.png"),
              fit: BoxFit.cover,
            ),
            imageUrl: item.url,
          )),
    );
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

  void showPhoto(BuildContext context, Results photo) {
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
