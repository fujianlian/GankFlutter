import 'dart:async';

import 'package:flutter_gank/models/DailyInfo.dart';
import 'package:flutter_gank/models/HistoryList.dart';
import 'package:flutter_gank/models/HotList.dart';
import 'package:flutter_gank/models/MsgInfo.dart';
import 'package:flutter_gank/models/PageList.dart';
import 'package:flutter_gank/models/banner_list.dart';
import 'package:flutter_gank/net/http_gank.dart';

/// gank信息获取
class GankApi {
  static Future<PageList> getListData(
      String type, int count, int pageIndex) async {
    var response;
    if(type=="app"){
       response = await HttpGank.getJson("data/category/GanHuo/type/$type/page/$pageIndex/count/$count", {});
    } else {
      response = await HttpGank.getJson("data/category/Article/type/$type/page/$pageIndex/count/$count", {});
    }
    return PageList.fromJson(response);
  }

  static Future<PageList> getGirlList(
      int count, int pageIndex) async {
    var response = await HttpGank.getJson("data/category/Girl/type/Girl/page/$pageIndex/count/$count", {});
    return PageList.fromJson(response);
  }

  static Future<DailyInfo> getDailyInfo(String date) async {
    var response = await HttpGank.getJson("day/$date", {});
    return DailyInfo.fromJson(response);
  }

  static Future<HotList> getHot() async {
    var response = await HttpGank.getJson("hot/likes/category/GanHuo/count/10", {});
    return HotList.fromJson(response);
  }

  static Future<BannerList> getBanners() async {
    var response = await HttpGank.getJson("banners", {});
    return BannerList.fromJson(response);
  }

  static Future<HistoryList> getHistory(int count, int pageIndex) async {
    var response =
        await HttpGank.getJson("history/content/$count/$pageIndex", {});
    return HistoryList.fromJson(response);
  }

  static Future<MsgInfo> release(Map<String, dynamic> map) async {
    var response = await HttpGank.postForm("add2gank", map);
    return MsgInfo.fromJson(response);
  }
}
