import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackless/async_state.dart';
import 'package:trackless/components/async_progress.dart';
import 'package:trackless/components/list_work/list_work.dart';
import 'package:trackless/date.dart';
import 'package:trackless/trackless/trackless_failure.dart';
import 'package:trackless/trackless/trackless_work.dart';

class HistoryPageWork extends StatefulWidget {
  final int weekNumber;
  final int year;

  HistoryPageWork({Key key, this.weekNumber, this.year}) : super(key: key);

  @override
  _HistoryPageWorkState createState() => _HistoryPageWorkState();
}

class _HistoryPageWorkState extends State<HistoryPageWork>
    with AfterLayoutMixin<HistoryPageWork> {
  @override
  void afterFirstLayout(BuildContext context) {
    // Get all the providers
    final tracklessWorkProvider =
        Provider.of<TracklessWorkProvider>(context, listen: false);
    final asyncState = Provider.of<AsyncState>(context, listen: false);

    // Get the first day of the week
    final DateTime firstDay =
        firstDayOfWeek(isoWeekToDate(widget.year, widget.weekNumber));

    // Clear the data
    tracklessWorkProvider.clearWorkList();

    // Get the data from the server
    () async {
      asyncState.isAsyncLoading = true;

      try {
        await tracklessWorkProvider.refreshFromServer(
            firstDay, firstDay.add(Duration(days: 6)));
      } on TracklessFailure catch (e) {
        e.displayFailure(context);

        if (e.code == 1) {
          // Offline error
          try {
            // Load the data from localStorage
            await tracklessWorkProvider.refreshFromLocalStorage(
                firstDay, firstDay.add(Duration(days: 6)));
          } on TracklessFailure catch (e) {
            e.displayFailure();
          }
        }
      }

      asyncState.isAsyncLoading = false;
    }();
  }

  @override
  Widget build(BuildContext context) {
    final tracklessWorkProvider = Provider.of<TracklessWorkProvider>(context);

    // Create a basic scaffold with a async loader and a listWork
    return WillPopScope(
        onWillPop: () async {
          // Clear the worklist for the home page
          tracklessWorkProvider.clearWorkList();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('${widget.year} - ${widget.weekNumber}'),
          ),
          body: CustomScrollView(
            slivers: [
              AsyncProgressSliver(),
              ...listWork(tracklessWorkProvider.sortedWorkList)
            ],
          ),
        ));
  }
}
