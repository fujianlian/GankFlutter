import 'dart:async';

import 'package:flutter_gank/models/DailyInfo.dart';
import 'package:flutter_gank/models/HistoryList.dart';
import 'package:flutter_gank/models/PageList.dart';
import 'package:flutter_gank/net/http_gank.dart';

/// gank信息获取
class GankApi {
  static Future<PageList> getListData(
      String type, int count, int pageIndex) async {
    var response = await HttpGank.getJson("data/$type/$count/$pageIndex", {});
    return PageList.fromJson(response);
  }

  static Future<DailyInfo> getDailyInfo(String date) async {
    var response = await HttpGank.getJson("day/$date", {});
    return DailyInfo.fromJson(response);
  }

  static Future<DailyInfo> getToday() async {
    var response = await HttpGank.getJson("today", {});
    return DailyInfo.fromJson(response);
  }

  static Future<HistoryList> getHistory(int count, int pageIndex) async {
    var response =
        await HttpGank.getJson("history/content/$count/$pageIndex", {});
    return HistoryList.fromJson(response);
  }
}
