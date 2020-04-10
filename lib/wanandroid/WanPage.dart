import 'package:flutter/material.dart';
import 'package:flutter_gank/colors.dart';
import 'package:flutter_gank/gank/CommonComponent.dart';
import 'package:flutter_gank/gank/WebPage.dart';
import 'package:flutter_gank/models/WanBannerInfo.dart';
import 'package:flutter_gank/models/WanList.dart';
import 'package:flutter_gank/net/api_wanandroid.dart';
import 'package:flutter_gank/widget/wan_banner.dart';

/// 各个分类列表显示
class WanPage extends StatefulWidget {
  WanPage({Key key, this.type}) : super(key: key);

  final String type;

  @override
  State<StatefulWidget> createState() {
    return new WanPageState();
  }
}

class WanPageState extends State<WanPage> with AutomaticKeepAliveClientMixin {
  List<Datas> _data = List();
  var _currentIndex = 0;

  /// 是否已加载完所有数据
  var _loadFinish = false;

  /// 是否正在加载数据
  bool isLoading = false;

  /// listView的控制器
  ScrollController _scrollController = ScrollController();

  double width = 0;

  List<BannerData> banners = [];

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
    if (banners.isEmpty) {
      await WanAndroidApi.getBanner().then((WanBannerInfo list) {
        if (list.data.isNotEmpty) {
          banners.addAll(list.data);
        }
      });
    }
    WanAndroidApi.getHomeList(_currentIndex, "").then((WanList list) {
      isLoading = false;
      setState(() {
        if (list.data.datas.isEmpty) {
          _loadFinish = true;
        } else {
          _data.addAll(list.data.datas);
        }
      });
    }).catchError((onError) {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('玩安卓'),
        centerTitle: true,
      ),
      body: _data.isEmpty
          ? LoadingWidget()
          : ListView.builder(
              itemBuilder: _renderRow,
              itemCount:
                  _loadFinish ? _data.length * 2 + 1 : _data.length * 2 + 2,
              controller: _scrollController,
            ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index == 0) {
      return _top();
    } else if (index % 2 == 0) {
      if (index == _data.length * 2)
        return Divider(height: 0, color: Colors.transparent);
      return Divider(height: 0.5, color: c9);
    } else if (index % 2 == 1) {
      int i = (index / 2).ceil() - 1;
      if (i < _data.length) {
        return WanListWidget(info: _data[i]);
      }
    }
    return _getMoreWidget();
  }

  Widget _top() {
    return Column(key: Key('__header__'), children: _pageSelector(context));
  }

  List<Widget> _pageSelector(BuildContext context) {
    List<Widget> list = [];
    if (banners.length > 0) {
      list.add(WanBanner(banners, (slider) {
        Navigator.push(context, new MaterialPageRoute(builder: (context) {
          return new WebPage(url: slider.url, title: slider.title);
        }));
      }));
    }
    return list;
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
