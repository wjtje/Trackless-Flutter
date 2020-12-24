import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/trackless/trackless_account.dart';
import 'package:trackless/trackless/trackless_failure.dart';

import '../../async_state.dart';

/// Start loading all the data needed for the account page
Future loadAccountPage(BuildContext context) async {
  final accountState = Provider.of<TracklessAccount>(context, listen: false);
  final asyncState = Provider.of<AsyncState>(context, listen: false);

  asyncState.isAsyncLoading = true;

  try {
    await accountState.refreshFromServer();
  } on TracklessFailure catch (e) {
    if (e.code != 1) {
      // Offile error
      e.displayFailure(context);
    } else {
      try {
        await accountState.refreshFromLocalStorage();
      } on TracklessFailure catch (e) {
        e.displayFailure(context);
      }
    }
  }

  // Wait a while for the animation
  await Future.delayed(Duration(seconds: 1));

  asyncState.isAsyncLoading = false;
}
