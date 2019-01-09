import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gank/models/HistoryList.dart';
import 'package:http/http.dart' as http;

import 'CommonComponent.dart';

/// 干货历史
class HistoryListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HistoryListPageState();
  }
}

class HistoryListPageState extends State<HistoryListPage>
    with AutomaticKeepAliveClientMixin {
  List<HistoryInfo> _data = List();
  var _count = 20;
  var _pageIndex = 1;

  /// 是否已加载完所有数据
  var _loadFinish = false;

  /// 是否正在加载数据
  bool isLoading = false;

  /// listView的控制器
  ScrollController _scrollController = ScrollController();

  IconData _backIcon(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

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
    var url = "http://gank.io/api/history/content/$_count/$_pageIndex";
    await http.get(url).then((http.Response response) {
      isLoading = false;
      var convertDataToJson = HistoryList.fromJson(json.decode(response.body));
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
    var con = context;
    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('干货历史'),
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(_backIcon(context)),
                onPressed: () {
                  Navigator.pop(con);
                },
              );
            },
          ),
        ),
        body: _data.isEmpty
            ? LoadingWidget()
            : ListView.builder(
                itemBuilder: _renderRow,
                itemCount: _loadFinish ? _data.length : _data.length + 1,
                controller: _scrollController,
              ),
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < _data.length) {
      return HistoryListWidget(info: _data[index]);
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
      _pageIndex++;
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
