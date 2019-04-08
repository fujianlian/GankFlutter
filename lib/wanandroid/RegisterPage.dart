import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gank/colors.dart';
import 'package:flutter_gank/models/github_user.dart';
import 'package:flutter_gank/net/api_github.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  var _name = "";
  var _pwd = "";
  var _pwd2 = "";
  var _isSubmit = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('注册'),
          centerTitle: true,
        ),
        body: new Stack(
          children: <Widget>[
            _layout(),
            _isSubmit
                ? IosLoadingWidget()
                : Container(
                    color: Colors.transparent,
                    height: 0.0,
                  ),
          ],
        ));
  }

  Widget _layout() {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 25.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Padding(
                  padding: new EdgeInsets.only(right: 10.0),
                  child: new Icon(
                    Icons.person,
                    size: 26,
                    color: Colors.grey,
                  ),
                ),
                new Expanded(
                  child: new TextField(
                      decoration: new InputDecoration(
                        hintText: '请输入用户名',
                      ),
                      onChanged: (str) {
                        _name = str;
                      }),
                )
              ]),
        ),
        new Padding(
          padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 36.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Padding(
                  padding: new EdgeInsets.only(right: 10.0),
                  child: new Icon(
                    Icons.lock,
                    size: 26,
                    color: Colors.grey,
                  ),
                ),
                new Expanded(
                  child: new TextField(
                    decoration: new InputDecoration(
                      hintText: '请输入密码',
                    ),
                    onChanged: (str) {
                      _pwd = str;
                    },
                    obscureText: true,
                  ),
                )
              ]),
        ),
        new Padding(
          padding: new EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 36.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Padding(
                  padding: new EdgeInsets.only(right: 10.0),
                  child: new Icon(
                    Icons.lock,
                    size: 26,
                    color: Colors.grey,
                  ),
                ),
                new Expanded(
                  child: new TextField(
                    decoration: new InputDecoration(
                      hintText: '请再次输入密码',
                    ),
                    onChanged: (str) {
                      _pwd2 = str;
                    },
                    obscureText: true,
                  ),
                )
              ]),
        ),
        new Container(
          width: 320.0,
          height: 44.0,
          child: new RaisedButton(
              onPressed: _login,
              color: mainColor,
              child: new Text(
                '登录',
                style: new TextStyle(color: Colors.white, fontSize: 16.0),
              )),
        ),
      ],
    );
  }

  void _login() {
    setState(() {
      _isSubmit = true;
    });
    GithubApi.login(_name, _pwd).then((user) {
      setState(() {
        _isSubmit = false;
      });
      _saveInfo(user);
    }).catchError((onError) {
      if (onError is DioError) {
        Fluttertoast.showToast(msg: onError.message);
        setState(() {
          _isSubmit = false;
        });
      } else {
        Fluttertoast.showToast(msg: "未知错误");
        setState(() {
          _isSubmit = false;
        });
      }
    });
  }

  void _saveInfo(User user) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", user.token);
    await prefs.setString("name", user.login);
    await prefs.setString("avatar_url", user.avatarUrl);
    await prefs.setInt("id", user.id);
    await prefs.setBool("isLogin", true);
    Navigator.of(context).pop(true);
  }
}

class IosLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Flex(
      mainAxisAlignment: MainAxisAlignment.center,
      direction: Axis.horizontal,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 262),
          child: new CupertinoActivityIndicator(
            radius: 14,
          ),
        ),
      ],
    );
  }
}
