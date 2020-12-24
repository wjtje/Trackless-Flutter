import 'package:flutter/material.dart';
import 'package:trackless/pages/home/home_load.dart';

class HomeRefreshAction extends StatelessWidget {
  const HomeRefreshAction({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.refresh), onPressed: () => loadHomePage(context));
  }
}
