import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  Color _color;

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).accentColor;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("关于"),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(15.0),
          children: <Widget>[_introduction(), _developer(), _openLibrary()],
        ));
  }

  /// 简介
  Widget _introduction() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text("简介",
            style: new TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0)),
        _line(),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
        ),
        new Text(
          "干货集中营是一款根据 Gank.io 官方提供的api实现的Gank客户端，包含最新数据展示，"
              "分类列表读取(Android，iOS，前端，休息视频，拓展资源，瞎推荐，App)，妹纸瀑布流图片"
              "，历史干货，提交干货以及玩安卓首页数据。",
          style: new TextStyle(height: 1.2),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
        ),
        new Text("顺手点个Star，需要您的支持。"),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
        ),
        new Row(
          children: <Widget>[
            new Text("项目源码："),
            _linkText(
                "GankFlutter", "https://github.com/fujianlian/GankFlutter")
          ],
        )
      ],
    );
  }

  /// 开发者
  Widget _developer() {
    return new Container(
        margin: EdgeInsets.only(top: 25.0, bottom: 25.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("开发者",
                style:
                    new TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0)),
            _line(),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            new Row(
              children: <Widget>[
                new Image(
                    image: AssetImage("images/github.png"),
                    height: 40,
                    width: 40),
                _linkText("fujianlian", "https://github.com/fujianlian")
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
            ),
            new Text("如果你在使用过程中遇到问题，欢迎给我提Issue。"),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            new Text("如果你有好的想法，欢迎pull request。"),
          ],
        ));
  }

  /// 开源库
  Widget _openLibrary() {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text("开源库",
              style:
                  new TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0)),
          _line(),
          _linkTextPadding("dio", "https://github.com/flutterchina/dio"),
          _linkTextPadding("connectivity", "https://github.com/flutter/plugins"),
          _linkTextPadding("fluttertoast", "https://github.com/PonnamKarthik/FlutterToast"),
          _linkTextPadding("shared_preferences", "https://github.com/flutter/plugins"),
          _linkTextPadding("cupertino_icons",
              "https://pub.dartlang.org/packages/cupertino_icons"),
          _linkTextPadding("json_annotation",
              "https://github.com/dart-lang/json_serializable"),
          _linkTextPadding("json_serializable",
              "https://github.com/dart-lang/json_serializable"),
          _linkTextPadding("webview_flutter",
              "https://pub.dartlang.org/packages/webview_flutter"),
          _linkTextPadding("cached_network_image",
              "https://github.com/renefloor/flutter_cached_network_image"),
          _linkTextPadding("url_launcher",
              "https://github.com/flutter/plugins/tree/master/packages/url_launcher"),
        ]);
  }

  Widget _line() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Divider(height: 0.0),
    );
  }

  Widget _linkText(String text, String url) {
    return new Column(
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            launch(url);
          },
          child: new Text(text,
              style: new TextStyle(
                color: _color,
                fontSize: 16.0,
                decoration: TextDecoration.underline,
              )),
        ),
      ],
    );
  }

  Widget _linkTextPadding(String text, String url) {
    return new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
        ),
        _linkText(text, url)
      ],
    );
  }
}
