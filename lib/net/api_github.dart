import 'dart:async';
import 'dart:convert';

import 'package:flutter_gank/models/github_user.dart';
import 'package:flutter_gank/net/http_github.dart';

/// github用户信息获取
class GithubApi {
  static Future<User> login(String username, String password) async {
    String token = await GithubApi.getAccessToken(username, password);
    return await getUserInfo(token);
  }

  static const List<String> OAUTH2_SCOPE = [
    'user',
    'repo',
    'gist',
    'notifications'
  ];

  static Future<String> getAccessToken(
      String userName, String password) async {
    String basic = "Basic ${base64Encode(utf8.encode("fujianlian:1235fjnbv"))}";
    HttpGithub.setHeader({"Authorization": basic, "cache-control": "no-cache"});
    var response = await HttpGithub.postJson("authorizations", {
      "client_id": "32a1d35d1df9b9b5757f",
      "client_secret": "e3c62486528d8a119c572daf23cafb25d826e546",
      "note": "com.github.fujianlian.fluttergank",
      "noteUrl": "http://localhost:8080/callback",
      "scopes": OAUTH2_SCOPE
    });
    String token = response['token'];
    return token;
  }

  static Future<User> getUserInfo(String accessToken) async {
    try {
      var response =
          await HttpGithub.postJson("user?access_token=$accessToken", {});
      User user = User.fromJson(response);
      return user;
    } catch (e) {
      return null;
    }
  }
}
