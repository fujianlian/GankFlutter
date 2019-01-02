import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebPage extends StatefulWidget {
  WebPage({Key key, this.url, this.title}) : super(key: key);

  final String url;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return new WebPageState();
  }
}

class WebPageState extends State<WebPage> {
  var contexts;
  bool _isLoading = true;
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  IconData _backIcon() {
    switch (Theme.of(contexts).platform) {
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
    flutterWebViewPlugin.onStateChanged.listen((state) {
      debugPrint('state:_' + state.type.toString());
      if (state.type == WebViewState.finishLoad) {
        // 加载完成
        setState(() {
          _isLoading = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        setState(() {
          _isLoading = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    contexts = context;

    return new Stack(children: <Widget>[
      new MaterialApp(
        routes: {
          "/": (_) => new WebviewScaffold(
                url: widget.url,
                appBar: new AppBar(
                  title: new Text(widget.title),
                  centerTitle: true,
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: Icon(_backIcon()),
                        onPressed: () {
                          Navigator.pop(contexts);
                        },
                      );
                    },
                  ),
                ),
              ),
        },
      ),
      new Container(
        height: window.physicalSize.height,
        child: new Center(
            child: _isLoading
                ? new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircularProgressIndicator(
                        strokeWidth: 3.0,
                      ),
                    ],
                  )
                : null),
      ),
    ]);
  }
}
