import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morpheus/morpheus.dart';
import 'package:provider/provider.dart';
import 'package:trackless/global/app_state.dart';
import 'package:trackless/functions/date.dart';
import 'package:trackless/global/async_state.dart';
import 'package:trackless/trackless/trackless_failure.dart';
import 'package:trackless/trackless/trackless_work.dart';

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
              onTap: () async {
                // Calculate the start end date of the week
                final DateTime firstDay =
                    firstDayOfWeek(isoWeekToDate(week[0], week[1]));
                final DateTime lastDay = firstDay.add(Duration(days: 6));

                // Get the provider
                final tracklessWorkProvider =
                    Provider.of<TracklessWorkProvider>(context, listen: false);
                final asyncState =
                    Provider.of<AsyncState>(context, listen: false);

                // Clear the data
                if (!firstDay
                        .isAtSameMomentAs(tracklessWorkProvider.startDate) ||
                    !lastDay.isAtSameMomentAs(tracklessWorkProvider.endDate)) {
                  tracklessWorkProvider.clearWorkList();
                }

                // Load the work bevore loading the page
                await tracklessWorkProvider.refreshFromLocalStorage(
                    firstDay, lastDay);

                () async {
                  asyncState.isAsyncLoading = true;

                  try {
                    await tracklessWorkProvider.refreshFromServer(
                        firstDay, lastDay);
                  } on TracklessFailure catch (e) {
                    e.displayFailure(context);
                  }

                  await Future.delayed(Duration(seconds: 1));

                  asyncState.isAsyncLoading = false;
                }();

                // Show the page
                Navigator.push(
                    context,
                    MorpheusPageRoute(
                        transitionColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        parentKey: listItemKey,
                        builder: (context) =>
                            HistoryPageWork(week[0], week[1])));
              },
            );
          },
        ))
      ],
    );
  }
}
