import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:trackless/app_localizations.dart';

import '../app.dart';

class TracklessFailure {
  final int code;
  final int detailCode;

  TracklessFailure(this.code, {this.detailCode = 0});

  @override
  String toString() {
    return ' (Code: ${this.code} - ${this.detailCode})';
  }

  /// Displays the failure using a snackbar
  displayFailure([BuildContext context]) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      (ScaffoldMessenger.of(context) ?? scaffoldKey.currentState)
          .showSnackBar(new SnackBar(
        content: Text(AppLocalizations.of(scaffoldKey.currentContext)
                .translate('error_${this.code}') +
            this.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }
}
