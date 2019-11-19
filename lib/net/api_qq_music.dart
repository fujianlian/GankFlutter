import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_gank/models/QQMusic.dart';

/// qq音乐推荐
class QQMusicApi {

  static final debug = !bool.fromEnvironment("dart.vm.product");

  /// 服务器路径
  static final baseUrl = 'https://c.y.qq.com/';

  /// 基础信息配置
  static final Dio _dio = new Dio(new BaseOptions(
      method: "get",
      baseUrl: baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 5000,
      followRedirects: true));

  /// 对请求返回的数据进行统一的处理
  /// 如果成功则将我们需要的数据返回出去，否则进异常处理方法，返回异常信息
  static Future<Map<String, dynamic>> logicalSuccessTransform<T>(
      Response<Map<String, dynamic>> resp) {
    if (resp.data != null) {
      return Future.value(resp.data);
    } else {
      return Future.value(null);
    }
  }

  static Future<QQMusic> getQQBanner() async {
    var response = await _dio.get("musichall/fcgi-bin/fcg_yqqhomepagerecommend.fcg");
    print(response.data);
    return QQMusic.fromJson(jsonDecode(response.toString()));
  }

}