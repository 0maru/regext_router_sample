import 'package:flutter/material.dart';

class SearchPageArgs {
  final int page;

  SearchPageArgs(
    Map<String, dynamic> args,
  ) : page = int.parse(args['page']);
}

class SearchPage extends StatelessWidget {
  static const path = '/search/';

  final SearchPageArgs args;

  const SearchPage._({
    Key key,
    this.args,
  }) : super(key: key);

  SearchPage.fromRouteArguments(Object body)
      : this._(args: SearchPageArgs(body as Map<String, dynamic>));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Text('page: ${args.page}'),
      ),
    );
  }
}
