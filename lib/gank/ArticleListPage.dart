import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'WebPage.dart';

/// 各个分类列表显示
class ArticleListPage extends StatefulWidget {
  ArticleListPage({Key key, this.type}) : super(key: key);

  final String type;

  @override
  State<StatefulWidget> createState() {
    return new ArticleListState();
  }
}

class ArticleListState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  List<Results> _data = List();
  var _currentIndex = 1;

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
    var irl = "http://gank.io/api/data/${widget.type}/15/$_currentIndex";
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
          : ListView.builder(
        itemBuilder: _renderRow,
        itemCount: _loadFinish ? _data.length : _data.length + 1,
        controller: _scrollController,
      ),
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
            //导航到新路由
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return new WebPage(url: item.url, title: item.desc);
            }));
          },
          child: new Card(
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: _getRowWidget(item),
            ),
            elevation: 3.0,
            margin: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
          )),
    );
  }

  Widget _getRowWidget(Results item) {
    return new Column(
      children: <Widget>[
        new Row(
          children: [
            new Expanded(
              child: new Text(
                item.desc,
                maxLines: 4,
                style: new TextStyle(fontSize: 16.0),
              ),
            ),
            item.images == null || item.images.isEmpty
                ? new Text("")
                : new Container(
                margin: EdgeInsets.only(left: 8.0),
                child: new CachedNetworkImage(
                  placeholder: Image(
                    image: AssetImage("images/holder.png"),
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                  fit: BoxFit.fitWidth,
                  imageUrl: item.images[0],
                  width: 90,
                  height: 90,
                )),
          ],
        ),
        new Container(
          margin: EdgeInsets.only(top: 8.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  item.who,
                  style:
                  new TextStyle(color: Color(0xFF888888), fontSize: 12.0),
                ),
              ),
              new Text(
                item.createdAt.substring(0, 10),
                style: new TextStyle(color: Color(0xFF888888), fontSize: 12.0),
              )
            ],
          ),
        )
      ],
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
