import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/gank/DailyPage.dart';
import 'package:flutter_gank/gank/WebPage.dart';
import 'package:flutter_gank/models/GankInfo.dart';
import 'package:flutter_gank/models/HistoryList.dart';

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

class HistoryListWidget extends StatelessWidget {
  HistoryListWidget({Key key, this.info}) : super(key: key);

  final HistoryInfo info;

  @override
  Widget build(BuildContext context) {
    RegExp exp = new RegExp(r'src=\"(.+?)\"');
    var imageUrl = exp.firstMatch(info.content).group(1);
    return new Container(
      child: new GestureDetector(
          onTap: () {
            //导航到新路由
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return new DailyPage(title: info.publishedAt.substring(0, 10));
            }));
          },
          child: new Container(
            color: Color(0xFFDFDFDF),
            child: new Stack(
              children: <Widget>[
                new Container(
                  child: new CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: imageUrl,
                    width: window.physicalSize.width - 20,
                    height: 170,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 15.0, top: 64, right: 15.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        info.publishedAt.substring(0, 10),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                      ),
                      new Text(
                        info.title,
                        maxLines: 3,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            margin: const EdgeInsets.all(4.0),
          )),
    );
  }
}
