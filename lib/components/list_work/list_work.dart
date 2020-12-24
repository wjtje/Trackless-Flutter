import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:trackless/components/list_work/list_work_skeleton.dart';
import 'package:trackless/trackless/models/trackless_work_model.dart';

import 'list_work_header.dart';
import 'list_work_item.dart';

/// Converts a [List<TracklessWork>] to a [List<Widget>]
List<Widget> listWork(List<TracklessWork> work) {
  if (work == null) {
    return [ListWorkSkeleton()];
  } else {
    List<TracklessWork> tmp = new List<TracklessWork>();
    List<List<TracklessWork>> parcedWork = new List<List<TracklessWork>>();
    String lastDate;

    // Sort the work by date
    work.forEach((element) {
      if (lastDate != element.date) {
        // Update the lastDate push tmp to parcedWork and clean the tmp
        lastDate = element.date;
        if (tmp.length > 0) {
          parcedWork.add(tmp);
        }
        tmp = new List<TracklessWork>();
      }

      tmp.add(element);
    });

    // Add the last
    parcedWork.add(tmp);

    List<Widget> slivers = [];

    // Build the slivers
    // Make sure the data is valid
    if (parcedWork[0].length > 0) {
      parcedWork.forEach((element) {
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
