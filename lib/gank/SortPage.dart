import 'package:flutter/material.dart';

import 'ArticleListPage.dart';

class SortPage extends StatefulWidget {
  @override
  SortPageState createState() => SortPageState();
}

class SortPageState extends State<SortPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;
  List<String> _allPages = <String>[
    'Android',
    'iOS',
    'Flutter',
    '前端',
    '后端',
    'App'
  ];
  
  List<String> _ids = <String>[
    'Android',
    'iOS',
    'Flutter',
    'frontend',
    'backend',
    'app'
  ];

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
        /*title: const Text('分类'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                      return new FabuPage();
                    }));
            },
          )
        ], */
        titleSpacing: 0,
        title: TabBar(
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
          children: _ids.map<Widget>((String page) {
            return new ArticleListPage(type: page);
          }).toList()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
