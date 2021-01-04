import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/global/app_state.dart';
import 'package:trackless/components/async_progress.dart';
import 'package:trackless/components/list_work/list_work.dart';
import 'package:trackless/pages/home/home_refresh_action.dart';
import 'package:trackless/trackless/trackless_work.dart';

import 'home_floating_action_button.dart';

final homePage = new AppPage(
    pageTitle: 'this_week_page_title',
    page: HomePage(),
    floatingActionButton: HomeFloatingActionButton(),
    appBarActions: [HomeRefreshAction()]);

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tracklessWorkProvider = Provider.of<TracklessWorkProvider>(context);

    return CustomScrollView(
      slivers: [
        AsyncProgressSliver(),
        ...listWork(tracklessWorkProvider.sortedWorkList)
      ],
    );
  }
}
