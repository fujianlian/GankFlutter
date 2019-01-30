import 'package:flutter/material.dart';
import 'package:flutter_gank/models/HistoryList.dart';
import 'package:flutter_gank/net/api_gank.dart';

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
    GankApi.getHistory(_count, _pageIndex).then((HistoryList list) {
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
    return new Scaffold(
      appBar: AppBar(
        title: Text('干货历史'),
        centerTitle: true,
      ),
      body: _data.isEmpty
          ? LoadingWidget()
          : ListView.builder(
              padding: EdgeInsets.all(4.0),
              itemBuilder: _renderRow,
              itemCount: _loadFinish ? _data.length : _data.length + 1,
              controller: _scrollController,
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
