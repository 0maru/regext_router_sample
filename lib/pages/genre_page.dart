import 'package:flutter/material.dart';

class GenrePageArgs {
  final String gender;

  GenrePageArgs(
    Map<String, dynamic> args,
  ) : gender = args['gender'];
}

class GenrePage extends StatelessWidget {
  static const path = '/genre/:gender/';

  final GenrePageArgs args;

  const GenrePage._({
    Key key,
    this.args,
  }) : super(key: key);

  GenrePage.fromRouteArguments(Object body)
      : this._(args: GenrePageArgs(body as Map<String, dynamic>));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: Text('genre: ${args.gender}')),
      ),
    );
  }
}
