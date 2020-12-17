import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../date.dart';
import 'HistoryWork.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(delegate: SliverChildBuilderDelegate(
          (context, i) {
            // Calculate the first day of the week and the week number
            DateTime newDate =
                firstDayOfWeek(DateTime.now().subtract(Duration(days: 7 * i)));
            List week = isoDateToWeek(newDate);

            // Display the week number and the range of that week
            return ListTile(
              title: Text('${week[0]}-W${week[1]}'),
              subtitle: Text(
                  '${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(newDate)} - ${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(newDate.add(Duration(days: 6)))}'),
              onTap: () {
                print('History: ${week[0]}-W${week[1]}');

                // Show the page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistoryWork(
                              year: week[0],
                              weekNumber: week[1],
                            )));
              },
            );
          },
        ))
      ],
    );
  }
}
