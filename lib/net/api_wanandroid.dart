import 'dart:async';

import 'package:flutter_gank/models/WanBanner.dart';
import 'package:flutter_gank/models/WanList.dart';
import 'package:flutter_gank/net/http_wanandroid.dart';

/// 玩安卓信息获取
class WanAndroidApi {
  static Future<WanList> getHomeList(int page, String cookie) async {
    var map = new Map<String, String>();
    map["cookie"] = cookie;
    HttpWanAndroid.setHeader(map);
    var response = await HttpWanAndroid.getJson("article/list/$page/json", {});
    return WanList.fromJson(response);
  }

  static Future<WanBanner> getBanner() async {
    var response = await HttpWanAndroid.getJson("banner/json", {});
    return WanBanner.fromJson(response);
  }

  static Future<WanBanner> login(Map map) async {
    var response = await HttpWanAndroid.postJson("user/login", map);
    return WanBanner.fromJson(response);
  }

  static Future<WanBanner> register(Map map) async {
    var response = await HttpWanAndroid.postJson("user/register", map);
    return WanBanner.fromJson(response);
  }
}
