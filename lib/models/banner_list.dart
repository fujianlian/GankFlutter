import 'dart:convert' show json;
import 'package:flutter_gank/models/gank.dart';

class BannerList extends Gank<List<BannerInfo>> {

  factory BannerList(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new BannerList.fromJson(json.decode(jsonStr))
          : new BannerInfo.fromJson(jsonStr);

  BannerList.fromJson(jsonRes) {
    status = jsonRes['status'];
    results = jsonRes['data'] == null ? null : [];

    for (var resultsItem in results == null ? [] : jsonRes['data']) {
      results
          .add(resultsItem == null ? null : new BannerInfo.fromJson(resultsItem));
    }
  }

  @override
  String toString() {
    return '{"status": $status,"results": $results}';
  }
}

class BannerInfo {

  String image;
  String title;
  String url;

  BannerInfo.fromParams(
      {
      this.image,
      this.title,
      this.url});

  BannerInfo.fromJson(jsonRes) {
    image = jsonRes['image'];
    title = jsonRes['title'];
    url = jsonRes['url'];
  }

  @override
  String toString() {
    return json.toString();
  }
}