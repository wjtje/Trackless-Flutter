import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackless/functions/app_failure.dart';
import 'package:trackless/global/app_state.dart';
import 'package:trackless/functions/date.dart';
import 'package:trackless/global/async_state.dart';
import 'package:trackless/trackless/trackless_work.dart';

import 'history_work.dart';

final historyPage =
    AppPage(pageTitle: 'history_page_title', page: HistoryPage());

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the provider
    final tracklessWorkProvider =
        Provider.of<TracklessWorkProvider>(context, listen: false);
    final asyncState = Provider.of<AsyncState>(context, listen: false);

    return CustomScrollView(
      slivers: [
        SliverList(delegate: SliverChildBuilderDelegate(
          (context, i) {
            // Calculate the first day of the week and the week number
            DateTime newDate =
                firstDayOfWeek(DateTime.now().subtract(Duration(days: 7 * i)));
            List week = isoDateToWeek(newDate);

            // Display the week number and the range of that week
            return OpenContainer(
                // The list tile
                closedColor: Theme.of(context).scaffoldBackgroundColor,
                closedElevation: 0,
                closedShape: RoundedRectangleBorder(),
                closedBuilder: (context, openContainer) => ListTile(
                      // The week code
                      title: Text('${week[0]} - ${week[1]}'),
                      // The date's
                      subtitle: Text(
                          '${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(newDate)} - ${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(newDate.add(Duration(days: 6)))}'),
                      // The function
                      onTap: () async {
                        // Calculate the start end date of the week
                        final DateTime firstDay =
                            firstDayOfWeek(isoWeekToDate(week[0], week[1]));
                        final DateTime lastDay =
                            firstDay.add(Duration(days: 6));

                        // Clear the data
                        if (!firstDay.isAtSameMomentAs(
                                tracklessWorkProvider.startDate) ||
                            !lastDay.isAtSameMomentAs(
                                tracklessWorkProvider.endDate)) {
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
                          } on AppFailure catch (e) {
                            e.displayFailure();
                          }

                          await Future.delayed(Duration(seconds: 1));

                          asyncState.isAsyncLoading = false;
                        }();

                        // Show the page
                        openContainer();
                      },
                    ),
                // The work dialog
                openColor: Theme.of(context).scaffoldBackgroundColor,
                openBuilder: (context, closeContainer) =>
                    HistoryPageWork(week[0], week[1]));
          },
        ))
      ],
    );
  }
}
