import 'package:flutter/material.dart';
import 'package:flutter_gank/net/api_gank.dart';
import 'package:flutter_gank/models/MsgInfo.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FabuPage extends StatefulWidget {
  @override
  _FabuPageState createState() => _FabuPageState();
}

class _FabuPageState extends State<FabuPage> {
  //网址控制器
  TextEditingController urlController = TextEditingController();

  //描述控制器
  TextEditingController descController = TextEditingController();

  //昵称控制器
  TextEditingController nameController = TextEditingController();

  final List<String> _allActivities = <String>[
    'Android',
    'iOS',
    'APP',
    '福利',
    '前端',
    '休息视频',
    '拓展资源',
    '瞎推荐',
  ];
  String _activity = 'Android';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('干货发布'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              send();
            },
          )
        ],
      ),
      body: DropdownButtonHideUnderline(
        child: SafeArea(
          top: false,
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: '网址',
                ),
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: '描述',
                ),
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '昵称',
                ),
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: '分类',
                  hintText: '',
                  contentPadding: EdgeInsets.zero,
                ),
                isEmpty: _activity == null,
                child: DropdownButton<String>(
                  value: _activity,
                  onChanged: (String newValue) {
                    setState(() {
                      _activity = newValue;
                    });
                  },
                  items: _allActivities
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void send() {
    if (urlController.text.length == 0) {
      Fluttertoast.showToast(
        msg: "请输入网址",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else if (descController.text.length == 0) {
      Fluttertoast.showToast(
        msg: "请输入描述",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else if (nameController.text.length == 0) {
      Fluttertoast.showToast(
        msg: "请输入昵称",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      Map<String, dynamic> map = Map();
      map["url"] = urlController.text;
      map["desc"] = descController.text;
      map["who"] = nameController.text;
      map["type"] = _activity;
      map["debug"] = false;
      GankApi.release(map).then((MsgInfo info) {
        if (info.error) {
          Fluttertoast.showToast(
            msg: info.msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        } else {
          Fluttertoast.showToast(
            msg: "发布成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          Navigator.of(context).pop(true);
        }
      });
    }
  }
}
