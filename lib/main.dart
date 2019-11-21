import 'package:flutter/material.dart';
import 'package:flutter_gank/store/index.dart';
import 'gank/MainPage.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter_bugly_plugin/flutter_bugly_plugin.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to Bugly.
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');

  print('Reporting to Bugly...');

  FlutterBuglyPlugin.postException(error, stackTrace);
}

Future<Null> main() async {
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails){
    print(flutterErrorDetails.toString());
    return Scaffold(
        body: Center(
          child: Text("Custom Error Widget"),
        )
    );
  };

  runZoned<Future<Null>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Store.init(child: MainPage()),
    );
  }
}