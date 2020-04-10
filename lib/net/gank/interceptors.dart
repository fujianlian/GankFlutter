import 'package:dio/dio.dart';

class HeaderInterceptor extends InterceptorsWrapper {

  @override
  Future onRequest(RequestOptions options) async {
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }
}

class DTOSInterceptor extends InterceptorsWrapper {
  @override
  Future onResponse(Response response) {
    // Process json convert
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    // Process error
    return super.onError(err);
  }
}
