import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkDownPage extends StatefulWidget {
  MarkDownPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return new MarkDownPageState();
  }
}
const String _markdownData = "https://github.com/fujianlian/GankFlutter/blob/master/README.md";

class MarkDownPageState extends State<MarkDownPage> {

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
    return new Scaffold(
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
        body: const Markdown(data: _markdownData)
    );
  }
}
