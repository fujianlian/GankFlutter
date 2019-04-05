import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  var _webViewController;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () {
          _goBack();
        },
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
          },
        ),
      ),
    );
  }

  void _goBack() async {
    if (await _webViewController.canGoBack()) {
      _webViewController.goBack();
    } else {
      Navigator.pop(context);
    }
  }
}
