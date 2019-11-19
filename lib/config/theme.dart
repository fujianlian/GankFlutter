import 'package:flutter/material.dart';
import 'color.dart' show materialColor;

/// 主题定义
class AppTheme {
  //static int mainColor = 0xFFD32F2F;
  static int mainColor = materialColor['gank'];
  static int secondColor = 0xFFFFFFFF;
  static int thirdColor = 0xFFFAFAFA;
  static int greyColor = 0x8A000000;
  static int blackColor = 0xFF000000;
  static int lineColor = 0xFFEEEEEE;

  static getThemeData(String theme) {
    print('==================================getThemeData=$theme');
    mainColor = materialColor[theme];
    ThemeData themData = ThemeData(
      textTheme: TextTheme(
        body1: TextStyle(
          // color: Colors.black,
          // fontWeight: FontWeight.bold,
        ),
      ),
      //platform: TargetPlatform.iOS,
      iconTheme: IconThemeData(
        size: 32,
        color: Color(thirdColor),
        opacity: 0.85,
      ),
      accentColor: Colors.white,
      // 选中颜色
      primaryColor: Color(mainColor),
      // 光标颜色
      cursorColor: Color(mainColor),
      // 背景颜色
      scaffoldBackgroundColor: Color(0xFFF7F7F7),
      // appbar背景
      primaryTextTheme: TextTheme(
          title: TextStyle(
            // color: Colors.red
          ),
          button: TextStyle(color: Colors.red)),
    );
    return themData;
  }
}
