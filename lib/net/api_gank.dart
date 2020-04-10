import 'dart:async';

import 'package:flutter_gank/models/DailyInfo.dart';
import 'package:flutter_gank/models/HistoryList.dart';
import 'package:flutter_gank/models/MsgInfo.dart';
import 'package:flutter_gank/net/http_gank.dart';

/// gank信息获取
class GankApi {

  static Future<DailyInfo> getDailyInfo(String date) async {
    var response = await HttpGank.getJson("day/$date", {});
    return DailyInfo.fromJson(response);
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
