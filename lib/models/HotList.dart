import 'dart:convert' show json;

import 'package:flutter_gank/models/GankInfo.dart';
import 'package:flutter_gank/models/gank.dart';

class HotList extends Gank<List<GankInfo>> {

  factory HotList(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new HotList.fromJson(json.decode(jsonStr))
          : new GankInfo.fromJson(jsonStr);

  HotList.fromJson(jsonRes) {
    status = jsonRes['status'];
    results = jsonRes['data'] == null ? null : [];

    for (var resultsItem in results == null ? [] : jsonRes['data']) {
      results
          .add(resultsItem == null ? null : new GankInfo.fromJson(resultsItem));
    }
  }

  @override
  String toString() {
    return '{"status": $status,"results": $results}';
  }
}
