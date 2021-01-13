import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:trackless/functions/app_localizations.dart';

class TracklessFailure {
  final int code;
  final int detailCode;

  TracklessFailure(this.code, {this.detailCode = 0});

  @override
  String toString() {
    return ' (Code: ${this.code} - ${this.detailCode})';
  }

  /// Displays the failure using a snackbar
  displayFailure(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text(
            AppLocalizations.of(context).translate('error_${this.code}') +
                this.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }
}
