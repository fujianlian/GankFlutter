import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:flutter_gank/net/gank/api.dart';
import 'package:flutter_gank/net/gank/apiService.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    request({}, APIService.getListData(widget.type, 10, _currentIndex)).then((res) {
      if (_currentIndex == 1) {
        _data.clear();
        _refreshController.refreshCompleted();
      } else {
        _refreshController.loadComplete();
      }
      for (int i = 0; i < res.data.length; i++) {
        _data.add(GankInfo.fromJson(res.data[i]));
      }
      isLoading = false;
      if (res.data.length < 10) {
        _loadFinish = true;
        _refreshController.loadNoData();
      }
      setState(() {});
    }).catchError((err) {
      if (_currentIndex == 1) {
        _refreshController.refreshCompleted();
      } else {
        _refreshController.loadComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      child:  ListView.builder(
              itemBuilder: _renderRow,
              itemCount: _data.length
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

  @override
  bool get wantKeepAlive => true;
}
