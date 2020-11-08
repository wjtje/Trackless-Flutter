import 'package:flutter/material.dart';
import 'package:trackless/bloc/work_event.dart';
import 'package:trackless/components/listWork.dart';
import 'package:trackless/date.dart';
import 'package:trackless/models/work.dart';
import 'package:trackless/bloc/work_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  final _workBloc = WorkBloc(
      startDate: firstDayOfWeek(DateTime.parse("2020-11-02")),
      endDate:
          firstDayOfWeek(DateTime.parse("2020-11-02")).add(Duration(days: 6)));

  _HomePageState() {
    // Update the work in the storage
    _workBloc.workEventSink.add(LoadWorkFromServer());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _workBloc.work,
        initialData: null,
        builder: (context, AsyncSnapshot<List<Work>> snapshot) =>
            CustomScrollView(
              slivers: [
                ...listWork(snapshot)
              ],
            ));
  }

  @override
  dispose() {
    _workBloc.dispose();
    super.dispose();
  }
}
