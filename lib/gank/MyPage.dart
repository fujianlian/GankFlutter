import 'package:flutter/material.dart';
import 'package:flutter_gank/gank/AboutPage.dart';
import 'package:flutter_gank/gank/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MyPageState();
  }
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  static var _color = Color(0xFFFCFCFC);
  static BuildContext _context;
  SharedPreferences _prefs;
  String _avatarUrl = "";
  String _name = "";
  var _isLogin = false;

  void _getInfo() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _refreshInfo();
  }

  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        centerTitle: true,
      ),
      body: new Container(
          color: Color(0xFFF0F0F0),
          child: ListView(
            children: <Widget>[_avatar(), _line()],
          )),
    );
  }

  void _refreshInfo() {
    setState(() {
      _isLogin = _prefs.getBool("isLogin") ?? false;
      _avatarUrl = _prefs.getString("avatar_url") ?? "";
      _name = _prefs.getString("name") ?? "";
    });
  }

  Widget _avatar() {
    return new Container(
      color: _color,
      padding: EdgeInsets.only(right: 16.0, top: 5.0, bottom: 5.0),
      child: new GestureDetector(
        onTap: () {
          if (!_isLogin) {
            Navigator.of(_context)
                .push(new MaterialPageRoute(builder: (context) {
              return new LoginPage();
            })).then((value) {
              if (value) {
                _refreshInfo();
              }
            });
          }
        },
        child: new Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15.0),
            ),
            new Expanded(
              child: new Text(
                _isLogin ? _name : 'Github账号登陆',
                style: new TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: new CachedNetworkImage(
                placeholder: (context, url) => new Image(
                  image: AssetImage("images/github_logo.png"),
                  width: 56,
                  height: 56,
                ),
                imageUrl: _avatarUrl,
                width: 56,
                height: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line() {
    return new Container(
      margin: EdgeInsets.only(top: 15.0),
      color: _color,
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text('点个star', style: new TextStyle(fontSize: 18.0)),
            trailing: new Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: () {
              launch("https://github.com/fujianlian/GankFlutter");
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Divider(height: 0.0),
          ),
          new ListTile(
            title: new Text('提Issue/PR', style: new TextStyle(fontSize: 18.0)),
            trailing: new Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: () {
              launch("https://github.com/fujianlian/GankFlutter/issues");
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Divider(height: 0.0),
          ),
          new ListTile(
            title: new Text('关于', style: new TextStyle(fontSize: 18.0)),
            trailing: new Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: () {
              Navigator.push(_context,
                  new MaterialPageRoute(builder: (context) {
                return new AboutPage();
              }));
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
