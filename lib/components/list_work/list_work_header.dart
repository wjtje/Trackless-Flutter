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
                // Display the day and date on the left
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the day on the top
                    Text(
                      DateFormat.EEEE(
                              Localizations.localeOf(context).languageCode)
                          .format(DateTime.parse(this.date)),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    // Display the date on the bottom
                    Text(
                      DateFormat.yMMMd(
                              Localizations.localeOf(context).languageCode)
                          .format(DateTime.parse(this.date)),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.74)),
                    )
                  ],
                ),
                // Display the total time on the right
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                      Text(
                          '${this.hours} ${AppLocalizations.of(context).translate('list_work_hour')}',
                          style: Theme.of(context).textTheme.caption.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary))
                    ])),
              ],
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SkeletonText(
                height: 14,
                padding: 1,
              ),
            ),
    );
  }
}
