import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/components/list_work/list_work.dart';
import 'package:trackless/trackless/trackless_work.dart';

class HistoryPageWork extends StatefulWidget {
  final int year;
  final int week;

  HistoryPageWork(this.year, this.week, {Key key}) : super(key: key);

  @override
  _HistoryPageWorkState createState() => _HistoryPageWorkState();
}

class _HistoryPageWorkState extends State<HistoryPageWork> {
  @override
  Widget build(BuildContext context) {
    final tracklessWorkProvider = Provider.of<TracklessWorkProvider>(context);

    // Create a basic scaffold with an Appbar and ListWork
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('${widget.year} - ${widget.week}'),
            ),
            body: ListWork(tracklessWorkProvider.sortedWorkList)));
  }
}
