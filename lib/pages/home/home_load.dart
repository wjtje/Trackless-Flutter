import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/global/async_state.dart';
import 'package:trackless/functions/date.dart';
import 'package:trackless/trackless/trackless_failure.dart';
import 'package:trackless/trackless/trackless_location.dart';
import 'package:trackless/trackless/trackless_work.dart';
import 'package:trackless/trackless/trackless_worktype.dart';

/// Start loading all the data needed for the home page
Future loadHomePage(BuildContext context) async {
  final startDate = firstDayOfWeek(DateTime.now());
  final endDate = startDate.add(Duration(days: 6));

  // Ger all the providers
  final tracklessWorkProvider =
      Provider.of<TracklessWorkProvider>(context, listen: false);
  final tracklessLocationProvider =
      Provider.of<TracklessLocationProvider>(context, listen: false);
  final tracklessWorktypeProvider =
      Provider.of<TracklessWorktypeProvider>(context, listen: false);

  final asyncState = Provider.of<AsyncState>(context, listen: false);

  // Loading
  asyncState.isAsyncLoading = true;

  try {
    // Load the data from localStorage
    await tracklessWorkProvider.refreshFromLocalStorage(startDate, endDate);
    await tracklessLocationProvider.refreshFromLocalStorage();
    await tracklessWorktypeProvider.refreshFromLocalStorage();

    // Try to load the data from the server
    await tracklessWorkProvider.refreshFromServer(startDate, endDate);
    await tracklessLocationProvider.refreshFromServer();
    await tracklessWorktypeProvider.refreshFromServer();
  } on TracklessFailure catch (e) {
    e.displayFailure();
  }

  // Wait a while for the animation
  await Future.delayed(Duration(seconds: 1));

  asyncState.isAsyncLoading = false;
}
