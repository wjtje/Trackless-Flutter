import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_failure.dart';
import 'package:trackless/trackless/trackless_account.dart';

import '../../global/async_state.dart';

/// Start loading all the data needed for the account page
Future loadAccountPage(BuildContext context) async {
  final accountState = Provider.of<TracklessAccount>(context, listen: false);
  final asyncState = Provider.of<AsyncState>(context, listen: false);

  asyncState.isAsyncLoading = true;

  try {
    await accountState.refreshFromServer();
  } on AppFailure catch (e) {
    e.displayFailure();

    if (e.failureLevel == 3) {
      // Offile error
      try {
        await accountState.refreshFromLocalStorage();
      } on AppFailure catch (e) {
        e.displayFailure();
      }
    }
  }

  // Wait a while for the animation
  await Future.delayed(Duration(seconds: 1));

  asyncState.isAsyncLoading = false;
}
