import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trackless/trackless/trackless_failure.dart';
import 'package:loader_overlay/loader_overlay.dart';

/// This function will try to run [function] and if it fails will display a dialog to inform the user
Future tryRequest(BuildContext context, Future Function() function) async {
  try {
    await function();
  } on SocketException {
    TracklessFailure(1).displayFailure(context); // No internet connection
  } on HttpException catch (e) {
    switch (e.message) {
      case '400':
        TracklessFailure(6, detailCode: 14)
            .displayFailure(context); // Bad request
        break;
      case '401':
        TracklessFailure(2).displayFailure(context); // Unauthorized
        break;
      case '403':
        TracklessFailure(2).displayFailure(context); // Forbidden
        break;
      case '404':
        TracklessFailure(3).displayFailure(context); // Not found
        break;
      default:
        TracklessFailure(4).displayFailure(context); // Internal server error
    }
  } on FormatException {
    TracklessFailure(5).displayFailure(context); // Internal error
  } on TypeError {
    TracklessFailure(5, detailCode: 15)
        .displayFailure(context); // Internal error
  } finally {
    // hide the loading animation
    context.hideLoaderOverlay();
  }
}
