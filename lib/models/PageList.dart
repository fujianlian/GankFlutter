import 'dart:convert' show json;

import 'package:flutter_gank/models/GankInfo.dart';

class PageList {
  bool error;
  List<GankInfo> results;

  PageList.fromParams({this.error, this.results});

  factory PageList(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new PageList.fromJson(json.decode(jsonStr))
          : new GankInfo.fromJson(jsonStr);

  PageList.fromJson(jsonRes) {
    error = jsonRes['error'];
    results = jsonRes['results'] == null ? null : [];

    for (var resultsItem in results == null ? [] : jsonRes['results']) {
      results
          .add(resultsItem == null ? null : new GankInfo.fromJson(resultsItem));
    }
  }

  @override
  String toString() {
    return '{"error": $error,"results": $results}';
  }
}
