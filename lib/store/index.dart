import 'package:flutter/material.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, MultiProvider, Provider;
export 'package:provider/provider.dart';
import './model/config_state_model.dart' show ConfigModel;

class Store {
  static BuildContext context;

  static of(BuildContext context) {
    Store.context ??= context;
    return context;
  }

  static init({child, context}) {
    Store.context ??= context;
    return MultiProvider(
      child: child,
      providers: [ChangeNotifierProvider(builder: (_) => ConfigModel())],
    );
  }

  static T value<T>([BuildContext context]) {
    context ??= Store.context;
    return Provider.of<T>(context);
  }
}
