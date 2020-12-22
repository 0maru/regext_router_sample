import 'package:flutter/cupertino.dart';
import 'package:regexp_router_sample/pages/genre_page.dart';
import 'package:regexp_router_sample/pages/home_page.dart';
import 'package:regexp_router_sample/pages/search_page.dart';
import 'package:regexp_router_sample/pages/web_view.dart';
import 'package:regexp_router_sample/utils.dart';

final router = Router.create({
  HomePage.path: (_, __) => HomePage(),
  GenrePage.path: (_, args) => GenrePage.fromRouteArguments(args.args),
  SearchPage.path: (_, args) => SearchPage.fromRouteArguments(args.args),
});

abstract class Router {
  Route<dynamic> generateRoute(RouteSettings settings);

  factory Router.create(Map<String, RouteBuilder> routeMap) => _RouterImpl(routeMap);
}

class _RouterImpl implements Router {
  final List<RouteEntity> _routerDict;

  _RouterImpl(Map<String, RouteBuilder> routeMap)
      : _routerDict = <RouteEntity>[
          for (var key in routeMap.keys)
            _buildRouteEntry(
              key,
              routeMap[key],
            ),
        ];

  @override
  Route generateRoute(RouteSettings settings) {
    try {
      String path = settings.name;
      Map query = <String, dynamic>{};
      if (path.contains('?')) {
        // クエリストリングを取り除く
        query = Uri.parse(path).queryParameters;
        path = path.split('?').first;
      }
      final routePath = _getRoutePath(path);
      RegExpMatch match;
      final routeEntry = _routerDict.firstWhere((r) {
        match = r.regex.firstMatch(routePath);
        return match != null;
      }, orElse: () => null);

      if (routeEntry == null) {
        // パスが無いときはWebViewで開く
        throw RouterNotFoundException();
      }

      var names = <String>[];
      if (match.groupCount > 0 && match.groupNames.isNotEmpty) {
        names = match.groupNames.toList();
      }

      final args = <String, dynamic>{
        for (var name in names) name: match.namedGroup(name),
      };
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => routeEntry.routeBuilder(
          context,
          RouteArgs(
            args..addAll(query),
            settings.arguments,
          ),
        ),
      );
    } on RouterNotFoundException {
      String url = settings.name;
      if (!url.startsWith('https')) {
        url = 'BASE_URL' + url;
      }
      return CupertinoPageRoute(builder: (_) => WebViewPage());
    }
  }
}

RouteEntity _buildRouteEntry(String name, RouteBuilder routeBuilder) {
  final params = _getRoutePath(name).replaceAllMapped(
    RegExp(':([a-zA-Z0-9_-]+)'),
    (match) {
      final groupName = match.group(1);
      return '(?<$groupName>.+[^/]+)';
    },
  );
  final regEx = RegExp('^$params\$', caseSensitive: false);
  return RouteEntity(name, regEx, routeBuilder);
}

String _getRoutePath(String name) {
  final parts = name.trim().split('/');
  parts.removeWhere((val) => val == '');
  parts.map((val) {
    if (val.startsWith(':')) {
      return val;
    } else {
      return val.toLowerCase();
    }
  });
  return parts.join('/');
}
