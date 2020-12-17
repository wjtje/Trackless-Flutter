import 'package:flutter/material.dart';

import '../bloc/work_bloc.dart';
import '../bloc/work_fromServer.dart';
import '../components/LinearProgress.dart';
import '../components/listWork.dart';
import '../date.dart';

class HistoryWork extends StatefulWidget {
  final int weekNumber;
  final int year;

  HistoryWork({Key key, this.weekNumber, this.year}) : super(key: key);

  @override
  _HistoryWorkState createState() => _HistoryWorkState();
}

class _HistoryWorkState extends State<HistoryWork>
    with SingleTickerProviderStateMixin, RouteAware {
  WorkBloc _workBloc;
  double loadingSize = 0.1; // loadingSize >= 0.1

  @override
  void initState() {
    DateTime firstDay =
        firstDayOfWeek(isoWeekToDate(widget.year, widget.weekNumber));

    // Create the workBloc
    _workBloc =
        WorkBloc(startDate: firstDay, endDate: firstDay.add(Duration(days: 6)));

    // Load work from server
    () async {
      // Show a loading animation
      setState(() {
        loadingSize = 4; // Default size
      });

      // Load the data and wait a some time for the animation
      await loadWorkFromServer(firstDay, firstDay.add(Duration(days: 6)));
      await new Future.delayed(const Duration(milliseconds: 2000));

      // Disable the loading animation
      if (this.mounted) {
        setState(() {
          loadingSize = 0.1; // Closed size
        });
      }
    }();

    super.initState();
  }

  @override
  void dispose() {
    _workBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show the app bar
      appBar: AppBar(
        title: Text('${widget.year}-W${widget.weekNumber}'),
      ),
      body: StreamBuilder(
        stream: _workBloc.work,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return CustomScrollView(
            slivers: [
              LinearPrograss(
                height: loadingSize,
              ),
              ...buildListWork(snapshot, loadingSize)
            ],
          );
        },
      ),
    );
  }
}
