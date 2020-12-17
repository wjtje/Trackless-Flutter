import 'package:flutter/material.dart';

import '../bloc/work_fromServer.dart';
import '../components/LinearProgress.dart';
import '../components/listWork.dart';
import '../date.dart';
import '../models/work.dart';
import '../bloc/work_bloc.dart';
import 'Work.dart';

final homePageFloatingActionButton = Builder(
    builder: (context) => FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkDialog(),
              ));
        }));

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, RouteAware {
  final _workBloc = WorkBloc(
      startDate: firstDayOfWeek(DateTime.now()),
      endDate: firstDayOfWeek(DateTime.now()).add(Duration(days: 6)));
  double loadingSize = 0.1; // loadingSize >= 0.1

  @override
  void initState() {
    super.initState();

    // Load work from server
    () async {
      // Show a loading animation
      setState(() {
        loadingSize = 4; // Default size
      });

      // Load the data and wait a some time for the animation
      await loadWorkFromServer(firstDayOfWeek(DateTime.now()),
          firstDayOfWeek(DateTime.now()).add(Duration(days: 6)));
      await new Future.delayed(const Duration(milliseconds: 2000));

      // Disable the loading animation
      if (this.mounted) {
        setState(() {
          loadingSize = 0.1; // Closed size
        });
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _workBloc.work,
        initialData: null,
        builder: (context, AsyncSnapshot<List<Work>> snapshot) =>
            CustomScrollView(
              slivers: [
                LinearPrograss(
                  height: loadingSize,
                ),
                ...buildListWork(snapshot, loadingSize)
              ],
            ));
  }

  @override
  dispose() {
    _workBloc.dispose();
    super.dispose();
  }
}
