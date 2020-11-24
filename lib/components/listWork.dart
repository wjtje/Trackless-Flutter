import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:trackless/app_localizations.dart';
import 'package:trackless/models/work.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:trackless/pages/Work.dart';

List<Widget> listWork(AsyncSnapshot<List<Work>> snapshot) {
  print('ListWork: parsing snapshot');

  print(snapshot.data);

  final List<Work> work = snapshot.data;

  // Load the slivers with default skeletons
  List<Widget> slivers = [
    Builder(
      builder: (context) => SliverStickyHeader(
        // Basic skeleton header
        header: Container(
          height: 60,
          color: Theme.of(context).primaryColorLight,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: Skeleton(
            height: 16,
            style: SkeletonStyle.text,
            baseColor: Colors.grey,
          ),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final Widget listItem = ListTile(
              title: Skeleton(
                height: 16,
                style: SkeletonStyle.text,
              ),
              subtitle: Skeleton(
                height: 12,
                style: SkeletonStyle.text,
              ),
              trailing: Skeleton(
                height: 16,
                width: 50,
                style: SkeletonStyle.text,
              ),
            );

            if (index + 1 == 15) {
              // Last one have extra spacing for lack of the divider
              return Column(
                children: [
                  listItem,
                  SizedBox(
                    height: 8,
                  ),
                ],
              );
            } else if (index == 0) {
              // For the first one
              return Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  listItem,
                  Divider(),
                ],
              );
            } else {
              return Column(
                children: [
                  listItem,
                  Divider(),
                ],
              );
            }
          }, childCount: 15),
        ),
      ),
    )
  ];

  // Sort the snapshot
  if (work != null) {
    List<Work> tmp = new List<Work>();
    List<List<Work>> parcedWork = new List<List<Work>>();
    String lastDate;

    work.forEach((element) {
      if (lastDate != element.date) {
        // Update the lastDate push tmp to parcedWork and clean the tmp
        lastDate = element.date;
        if (tmp.length > 0) {
          parcedWork.add(tmp);
        }
        tmp = new List<Work>();
      }

      tmp.add(element);
    });

    // Add the last
    parcedWork.add(tmp);

    slivers = []; // Clear the list

    // Build the slivers
    // Make sure the data is valid
    if (parcedWork[0].length > 0) {
      parcedWork.forEach((element) {
        // Calculate the total hours
        double hours = 0;

        element.forEach((element) {
          hours += element.time;
        });

        slivers.add(SliverStickyHeader(
          header: ListWorkHeader(
            date: element[0].date,
            hours: double.parse((hours).toStringAsFixed(2)), // It's ugly but it's work
          ),
          sliver: ListWorkSliver(
            work: element,
          ),
        ));
      });
    }
  }

  return slivers;
}

class ListWorkHeader extends StatelessWidget {
  final String date;
  final double hours;

  const ListWorkHeader({Key key, this.date, this.hours}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Theme.of(context).primaryColorLight,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Display the Date on the left
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
                      .format(DateTime.parse(this.date)),
                  style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(
                      // Make sure the text has the correct color
                      color: Theme.of(context).colorScheme.onPrimary))),
            ],
          ),
          // Display the total hours on the right
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  '${this.hours.toString()} ${AppLocalizations.of(context).translate('list_work_total')}',
                  style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(
                      // Make sure the text has the correct color
                      color: Theme.of(context).colorScheme.onPrimary))),
            ],
          ))
        ],
      ),
    );
  }
}

class ListWorkSliver extends StatelessWidget {
  final List<Work> work;

  const ListWorkSliver({Key key, this.work}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      final tile = ListTile(
        title: Text(
            work[index].location.place + ' - ' + work[index].location.name),
        subtitle: Text(work[index].description),
        trailing: Text(
            '${work[index].time.toString()} ${AppLocalizations.of(context).translate('list_work_hour')}'),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkDialog(
                  editWork: work[index],
                ),
              ))
        },
      );

      if (index + 1 == this.work.length) {
        // Last one have extra spacing for lack of the divider
        return Column(
          children: [
            tile,
            SizedBox(
              height: 8,
            ),
          ],
        );
      } else if (index == 0) {
        // For the first one
        return Column(
          children: [
            SizedBox(
              height: 8,
            ),
            tile,
            Divider(),
          ],
        );
      } else {
        return Column(
          children: [
            tile,
            Divider(),
          ],
        );
      }
    }, childCount: work.length));
  }
}
