import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const path = '/home/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (var p in paths)
            ListTile(
              title: Text(p),
              onTap: () {
                Navigator.pushNamed(context, p);
              },
            ),
        ],
      ),
    );
  }
}

const paths = [
  '/genre/men/',
  '/search/?page=10',
];
