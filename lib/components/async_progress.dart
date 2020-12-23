import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/app_state.dart';

/// A LinearProgressIndicator that will show when the
/// isAsyncLoading is active in the app_state
class AsyncProgress extends StatefulWidget {
  AsyncProgress({Key key}) : super(key: key);

  @override
  _AsyncProgressState createState() => _AsyncProgressState();
}

class _AsyncProgressState extends State<AsyncProgress>
    with SingleTickerProviderStateMixin {
  /// The current height of the Progress Indicator
  double _height = 4.0;

  @override
  Widget build(BuildContext context) {
    // Get the current app state
    final appState = Provider.of<AppState>(context);

    // Only set the state when it not already set
    // This is for preformance reasons
    if (!appState.isAsyncLoading && _height == 4.0) {
      // Hide it
      setState(() {
        _height = 0.1;
      });
    } else if (appState.isAsyncLoading && _height == 0.1) {
      // Show it
      setState(() {
        _height = 4;
      });
    }

    // Animate the size
    return AnimatedSize(
        duration: Duration(milliseconds: 150),
        vsync: this,
        // Disable the LinearProgressIndicator if the size == 0.1
        child: Visibility(
          child: LinearProgressIndicator(
            minHeight: _height,
          ),
          visible: _height != 0.1,
        ),
        curve: Curves.fastOutSlowIn);
  }
}
