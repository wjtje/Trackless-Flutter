import 'package:flutter/material.dart';

class LinearPrograss extends StatefulWidget {
  final double height;

  LinearPrograss({Key key, this.height}) : super(key: key);

  @override
  _LinearPrograssState createState() => _LinearPrograssState();
}

class _LinearPrograssState extends State<LinearPrograss>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            // Animate the size of the LinearProgressIndicator
            (context, i) => AnimatedSize(
                duration: Duration(milliseconds: 150),
                vsync: this,
                // Disable the LinearProgressIndicator if the size == 0.1
                child: Visibility(
                  child: LinearProgressIndicator(
                    minHeight: widget.height,
                  ),
                  visible: widget.height != 0.1,
                ),
                curve: Curves.fastOutSlowIn),
            childCount: 1));
  }
}
