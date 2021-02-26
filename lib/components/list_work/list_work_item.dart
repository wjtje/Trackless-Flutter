import 'package:flutter/material.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/pages/work_dialog/work_dialog.dart';
import 'package:trackless/trackless/models/trackless_work_model.dart';
import 'package:animations/animations.dart';

/// A item for listWork
class ListWorkItem extends StatelessWidget {
  final TracklessWork work;

  ListWorkItem({Key key, this.work}) : super(key: key);

  final listItemKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      // The closed widget
      // e.g. The list item with basic information
      closedColor: Theme.of(context).scaffoldBackgroundColor,
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(),
      closedBuilder: (context, openContainer) => ListTile(
        // Title: location
        title: (work != null)
            ? Text(
                work.location.fullName,
                overflow: TextOverflow.ellipsis,
              )
            : SkeletonText(
                height: 12,
                padding: 1,
              ),
        // Subtitle: Description
        subtitle: (work != null)
            ? Text(work.description, overflow: TextOverflow.ellipsis)
            : SkeletonText(
                height: 10,
                padding: 1,
              ),
        // Trailing: Time
        trailing: (work != null)
            ? Text(
                '${work.time.toString()} ${AppLocalizations.of(context).translate('list_work_hour')}',
                style: Theme.of(context).textTheme.caption)
            : Skeleton(
                style: SkeletonStyle.text,
                height: 12,
                padding: 1,
                width: 80,
              ),
        // Open the container on tap
        onTap: openContainer,
      ),
      // The open widget
      // e.g. The work edit dialog
      openColor: Theme.of(context).scaffoldBackgroundColor,
      openBuilder: (context, closeContainer) => WorkDialog(work),
    );
  }
}
