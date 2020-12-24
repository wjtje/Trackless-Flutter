import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/async_state.dart';
import 'package:trackless/date.dart';
import 'package:trackless/trackless/trackless_failure.dart';
import 'package:trackless/trackless/trackless_work.dart';

/// Start loading all the data needed for the home page
Future loadHomePage(BuildContext context) async {
  final startDate = firstDayOfWeek(DateTime.now());
  final endDate = startDate.add(Duration(days: 6));

  final tracklessWorkProvider =
      Provider.of<TracklessWorkProvider>(context, listen: false);
  final asyncState = Provider.of<AsyncState>(context, listen: false);

  asyncState.isAsyncLoading = true;

  try {
    await tracklessWorkProvider.refreshFromServer(startDate, endDate);
  } on TracklessFailure catch (e) {
    e.displayFailure(context);
  }

  // Wait a while for the animation
  await Future.delayed(Duration(seconds: 1));

  asyncState.isAsyncLoading = false;
}
