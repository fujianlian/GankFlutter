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
  Widget build(BuildContext context) {
    contexts = context;
    return new MaterialApp(
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
    );
  }
}
