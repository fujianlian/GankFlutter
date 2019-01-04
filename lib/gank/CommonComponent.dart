import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/gank/WebPage.dart';
import 'package:flutter_gank/models/GankInfo.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      height: window.physicalSize.height,
      child: new Center(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
          new Container(
              padding: EdgeInsets.only(top: 10.0), child: new Text("正在加载")),
        ],
      )),
    );
  }
}

class ShowListWidget extends StatelessWidget {
  ShowListWidget({Key key, this.info, this.contexts}) : super(key: key);

  final GankInfo info;
  final BuildContext contexts;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: new GestureDetector(
          onTap: () {
            //导航到新路由
            Navigator.push(contexts == null ? context : contexts,
                new MaterialPageRoute(builder: (context) {
              return new WebPage(url: info.url, title: info.desc);
            }));
          },
          child: new Card(
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: _getRowWidget(),
            ),
            elevation: 3.0,
            margin: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
          )),
    );
  }

  Widget _getRowWidget() {
    return new Column(
      children: <Widget>[
        new Row(
          children: [
            new Expanded(
              child: new Text(
                info.desc,
                maxLines: 4,
                style: new TextStyle(fontSize: 16.0),
              ),
            ),
            info.images == null || info.images.isEmpty
                ? new Text("")
                : new Container(
                    margin: EdgeInsets.only(left: 8.0),
                    child: new CachedNetworkImage(
                      placeholder: Image(
                        image: AssetImage("images/holder.png"),
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                      fit: BoxFit.fitWidth,
                      imageUrl: info.images[0],
                      width: 90,
                      height: 90,
                    )),
          ],
        ),
        new Container(
          margin: EdgeInsets.only(top: 8.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(
                  info.who,
                  style:
                      new TextStyle(color: Color(0xFF888888), fontSize: 12.0),
                ),
              ),
              new Text(
                info.createdAt.substring(0, 10),
                style: new TextStyle(color: Color(0xFF888888), fontSize: 12.0),
              )
            ],
          ),
        )
      ],
    );
  }
}
