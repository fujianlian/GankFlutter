import 'package:flutter/material.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:flutter_gank/models/PageList.dart';
import 'package:flutter_gank/net/api_gank.dart';

import 'CommonComponent.dart';

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
  List<GankInfo> _data = List();
  var _currentIndex = 1;

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
    GankApi.getListData(widget.type, 10, _currentIndex).then((PageList list) {
      isLoading = false;
      print(list);
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
      body: _data.isEmpty
          ? LoadingWidget()
          : ListView.builder(
              itemBuilder: _renderRow,
              itemCount: _loadFinish ? _data.length : _data.length + 1,
              controller: _scrollController,
            ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < _data.length) {
      return ShowListWidget(info: _data[index]);
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
