import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morpheus/morpheus.dart';
import 'package:trackless/global/app_state.dart';
import 'package:trackless/functions/date.dart';

import 'history_work.dart';

final historyPage =
    AppPage(pageTitle: 'history_page_title', page: HistoryPage());

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(delegate: SliverChildBuilderDelegate(
          (context, i) {
            final listItemKey = GlobalKey();

            // Calculate the first day of the week and the week number
            DateTime newDate =
                firstDayOfWeek(DateTime.now().subtract(Duration(days: 7 * i)));
            List week = isoDateToWeek(newDate);

            // Display the week number and the range of that week
            return ListTile(
              key: listItemKey,
              title: Text('${week[0]} - ${week[1]}'),
              subtitle: Text(
                  '${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(newDate)} - ${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(newDate.add(Duration(days: 6)))}'),
              onTap: () {
                // Show the page
                Navigator.push(
                    context,
                    MorpheusPageRoute(
                        transitionColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        parentKey: listItemKey,
                        builder: (context) => HistoryPageWork(
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
