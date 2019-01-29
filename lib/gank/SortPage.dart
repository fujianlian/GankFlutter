import 'package:flutter/material.dart';

import 'ArticleListPage.dart';

const List<String> _allPages = <String>[
  '全部',
  'Android',
  'iOS',
  '前端',
  '休息视频',
  '拓展资源',
  '瞎推荐',
  'App'
];

class SortPage extends StatefulWidget {
  @override
  SortPageState createState() => SortPageState();
}

class SortPageState extends State<SortPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allPages.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分类'),
        centerTitle: true,
        bottom: TabBar(
          controller: _controller,
          isScrollable: true,
          tabs: _allPages
              .map<Tab>(
                (String page) => Tab(text: page),
              )
              .toList(),
        ),
      ),
      body: TabBarView(
          controller: _controller,
          children: _allPages.map<Widget>((String page) {
            if (page == '全部') return new ArticleListPage(type: "all");
            return new ArticleListPage(type: page);
          }).toList()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
