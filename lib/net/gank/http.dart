import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';
import './apiService.dart';
import './interceptors.dart';

final http = Http();

class Http extends DioForNative {
  
  static Http _instance = Http._().._initialize();

  factory Http() {
    return _instance; 
  }

  Http._();

  _initialize() {
    options.baseUrl = APIService.baseUrl;
    options.connectTimeout = 10000;
    options.receiveTimeout = 5000;
    options.contentType = Headers.jsonContentType;
    (transformer as DefaultTransformer).jsonDecodeCallback = (json) => compute(jsonDecode, json);

    interceptors.add(HeaderInterceptor());
    interceptors.add(DTOSInterceptor());
    interceptors.add(LogInterceptor());

    (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      /* client.badCertificateCallback =
           (X509Certificate cert, String host, int port) {
           return true;
       };*/

      // 设置代理
      // client.findProxy = (uri) => "PROXY 192.168.101.15:8888";        
    };
  }
}