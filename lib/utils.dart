import 'package:flutter/material.dart';

typedef RouteBuilder = Widget Function(BuildContext context, RouteArgs args);

class RouteArgs {
  /// path で指定したURLの :id/ の部分
  /// query_string
  final Map<String, dynamic> args;

  /// settings で渡した引数
  final Object body;

  RouteArgs(
    this.args, [
    this.body,
  ]);

  String operator [](String key) => args[key];
}

class RouteEntity {
  final String name;
  final RegExp regex;
  final RouteBuilder routeBuilder;

  RouteEntity(
    this.name,
    this.regex,
    this.routeBuilder,
  );
}

class RouterNotFoundException implements Exception {
  const RouterNotFoundException();

  @override
  String toString() => 'RouterNotFoundException';
}
