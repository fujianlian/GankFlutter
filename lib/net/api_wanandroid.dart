import 'dart:async';

import 'package:flutter_gank/models/WanBannerInfo.dart';
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

  static Future<WanBannerInfo> getBanner() async {
    var response = await HttpWanAndroid.getJson("banner/json", {});
    return WanBannerInfo.fromJson(response);
  }

  static Future<WanBannerInfo> login(Map map) async {
    var response = await HttpWanAndroid.postJson("user/login", map);
    return WanBannerInfo.fromJson(response);
  }

  static Future<WanBannerInfo> register(Map map) async {
    var response = await HttpWanAndroid.postJson("user/register", map);
    return WanBannerInfo.fromJson(response);
  }
}
