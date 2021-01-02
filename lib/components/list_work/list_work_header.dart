import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_animation/skeleton_animation.dart';

import '../../functions/app_localizations.dart';

/// A headers for listWork
class ListWorkHeader extends StatelessWidget {
  final String date;
  final String hours;

  const ListWorkHeader({Key key, this.date, this.hours}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Theme.of(context).primaryColorLight,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: (this.date != null && this.hours != null)
          ? Row(
              children: [
                // Display the date on the left
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        DateFormat.yMMMd(
                                Localizations.localeOf(context).languageCode)
                            .format(DateTime.parse(this.date)),
                        style: Theme.of(context).textTheme.subtitle1.merge(
                              TextStyle(
                                  // Make sure the text has the correct color
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            )),
                  ],
                ),
                // Display the total time on the right
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                      Text(
                          '${this.hours} ${AppLocalizations.of(context).translate('list_work_total')}',
                          style: Theme.of(context).textTheme.bodyText2.merge(
                              TextStyle(
                                  // Make sure the text has the correct color
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)))
                    ])),
              ],
            )
          : SkeletonText(
              height: 14,
              padding: 1,
            ),
    );
  }
}
