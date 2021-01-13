import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:trackless/components/list_work/list_work_skeleton.dart';
import 'package:trackless/trackless/models/trackless_work_model.dart';

import '../async_progress.dart';
import 'list_work_header.dart';
import 'list_work_item.dart';

class ListWork extends StatelessWidget {
  final List<List<TracklessWork>> work;

  /// This will display a [List<List<TracklessWork>>] and show the correct state
  const ListWork(this.work, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Still loading
    if (this.work == null) {
      return CustomScrollView(
        slivers: [AsyncProgressSliver(), ListWorkSkeleton()],
      );
    } else if (this.work[0].length == 0) {
      // There is no work
      return Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'It\'s empty in here',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 8,
            ),
            // Text
            Text(
              'If you save some work for this week,\nit will show up in here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2.apply(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(.74)),
            )
          ],
        )),
      );
    } else {
      // Show the work
      return CustomScrollView(
        slivers: [AsyncProgressSliver(), ...listWork(this.work)],
      );
    }
  }
}

/// Converts a [List<TracklessWork>] to a [List<Widget>]
List<Widget> listWork(List<List<TracklessWork>> work) {
  if (work == null) {
    return [ListWorkSkeleton()];
  } else {
    List<Widget> slivers = [];

    // Build the slivers
    // Make sure the data is valid
    if (work[0].length > 0) {
      work.forEach((element) {
        // Calculate the total hours
        double hours = 0;

        element.forEach((element) {
          hours += element.time;
        });

        // Build the sliver
        slivers.add(SliverStickyHeader(
          // Create the header
          header: ListWorkHeader(
            date: element[0].date,
            hours: double.parse(hours.toStringAsFixed(2))
                .toString(), // It's ugly but it's work
          ),

          // Create the sliver
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => ListWorkItem(
                      work: element[index],
                    ),
                childCount: element.length),
          ),
        ));
      });
    }

    return slivers;
  }
}
