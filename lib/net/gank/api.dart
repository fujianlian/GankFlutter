import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import './http.dart';

export './apiService.dart';

class Result {
  dynamic data;

  int status;
  String reason;

  Result(this.status, this.reason, this.data);

  Result.fromJSON(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"];
  }
}

Future<Result> request(Map<String, dynamic> data, String url,
    {String method = "GET", FormData formData}) async {
  try {
    var response = await http.request(
      url,
      data: formData == null ? data : formData,
      queryParameters: data,
      options: Options(method: method),
    );
    if (response.statusCode == HttpStatus.ok) {
      final res = Result.fromJSON(response.data);
      return res;
      // res.returnCode 统一处理业务响应错误
    } else {
      final result = Result(response.statusCode, "", null);
      return Future.error(result);
    }
  } catch (e) {
    debugPrint(e.toString());
    final result = Result(e.response.statusCode, e.message, null);
    return Future.error(result);
  }
}
