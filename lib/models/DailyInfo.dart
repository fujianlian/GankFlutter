import 'dart:convert' show json;

import 'package:flutter_gank/models/GankInfo.dart';

class DailyInfo {
  bool error;
  List<String> category;
  Child results;

  DailyInfo.fromParams({this.error, this.category, this.results});

  factory DailyInfo(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new DailyInfo.fromJson(json.decode(jsonStr))
          : new DailyInfo.fromJson(jsonStr);

  DailyInfo.fromJson(jsonRes) {
    error = jsonRes['error'];
    category = jsonRes['category'] == null ? null : [];

    for (var categoryItem in category == null ? [] : jsonRes['category']) {
      category.add(categoryItem);
    }

    results = jsonRes['results'] == null
        ? null
        : new Child.fromJson(jsonRes['results']);
  }

  @override
  String toString() {
    return '{"error": $error,"category": $category,"results": $results}';
  }
}

class Child {
  List<GankInfo> android;
  List<GankInfo> iOS;
  List<GankInfo> video;
  List<GankInfo> resource;
  List<GankInfo> fuli;

  Child.fromParams(
      {this.android, this.iOS, this.video, this.resource, this.fuli});

  Child.fromJson(jsonRes) {
    android = jsonRes['Android'] == null ? null : [];

    for (var androidItem in android == null ? [] : jsonRes['Android']) {
      android
          .add(androidItem == null ? null : new GankInfo.fromJson(androidItem));
    }

    iOS = jsonRes['iOS'] == null ? null : [];

    for (var iOSItem in iOS == null ? [] : jsonRes['iOS']) {
      iOS.add(iOSItem == null ? null : new GankInfo.fromJson(iOSItem));
    }

    video = jsonRes['休息视频'] == null ? null : [];

    for (var videoItem in video == null ? [] : jsonRes['休息视频']) {
      video.add(videoItem == null ? null : new GankInfo.fromJson(videoItem));
    }

    resource = jsonRes['拓展资源'] == null ? null : [];

    for (var resourceItem in resource == null ? [] : jsonRes['拓展资源']) {
      resource.add(
          resourceItem == null ? null : new GankInfo.fromJson(resourceItem));
    }

    fuli = jsonRes['福利'] == null ? null : [];

    for (var fuliItem in fuli == null ? [] : jsonRes['福利']) {
      fuli.add(fuliItem == null ? null : new GankInfo.fromJson(fuliItem));
    }
  }

  @override
  String toString() {
    return '{"android": $android,"iOS": $iOS,"休息视频": $video,"拓展资源": $resource,"福利": $fuli}';
  }
}
