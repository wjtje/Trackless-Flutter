import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global/async_state.dart';

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
    final asyncState = Provider.of<AsyncState>(context);

    // Only set the state when it not already set
    // This is for preformance reasons
    if (!asyncState.isAsyncLoading && _height == 4.0) {
      // Hide it
      setState(() {
        _height = 0.1;
      });
    } else if (asyncState.isAsyncLoading && _height == 0.1) {
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

/// A sliver version of the asyncProgress widget
class AsyncProgressSliver extends StatelessWidget {
  const AsyncProgressSliver({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, i) => AsyncProgress(),
            childCount: 1));
  }
}
