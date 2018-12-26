import 'package:flutter/material.dart';

class _Page {
  const _Page({this.icon, this.text});

  final IconData icon;
  final String text;
}

const List<String> _allPages = <String>[
  '福利',
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
    with SingleTickerProviderStateMixin {
  TabController _controller;
  bool _customIndicator = false;

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

  Decoration getIndicator() {
    if (!_customIndicator) return const UnderlineTabIndicator();
    return ShapeDecoration(
      shape: const StadiumBorder(
            side: BorderSide(
              color: Colors.white24,
              width: 2.0,
            ),
          ) +
          const StadiumBorder(
            side: BorderSide(
              color: Colors.transparent,
              width: 4.0,
            ),
          ),
    );
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
          indicator: getIndicator(),
          tabs: _allPages.map<Tab>((String page) {
            return Tab(text: page);
          }).toList(),
        ),
      ),
      body: TabBarView(
          controller: _controller,
          children: _allPages.map<Widget>((String page) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Container(
                key: ObjectKey(page),
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  child: Center(
                    child: Text(
                      page
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }
}
