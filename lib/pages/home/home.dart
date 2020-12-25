import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/app_state.dart';
import 'package:trackless/components/async_progress.dart';
import 'package:trackless/components/list_work/list_work.dart';
import 'package:trackless/pages/home/home_refresh_action.dart';
import 'package:trackless/trackless/trackless_failure.dart';
import 'package:trackless/trackless/trackless_work.dart';

final homePage = new AppPage(
    pageTitle: 'this_week_page_title',
    page: HomePage(),
    appBarActions: [
      HomeRefreshAction(),
      Builder(
          builder: (context) => IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                final tracklessWorkProvider =
                    Provider.of<TracklessWorkProvider>(context, listen: false);

                tracklessWorkProvider.workList = null;
              })),
      Builder(
          builder: (context) => IconButton(
              icon: Icon(Icons.folder_open),
              onPressed: () async {
                final tracklessWorkProvider =
                    Provider.of<TracklessWorkProvider>(context, listen: false);

                try {
                  await tracklessWorkProvider.refreshFromLocalStorage(
                      tracklessWorkProvider.startDate,
                      tracklessWorkProvider.endDate);
                } on TracklessFailure catch (e) {
                  // Something went wrong
                  // Create a snackbar to alert the user
                  e.displayFailure();
                }
              }))
    ]);

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
