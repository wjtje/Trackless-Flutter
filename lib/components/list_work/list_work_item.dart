import 'package:flutter/material.dart';
import 'package:morpheus/morpheus.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:trackless/functions/app_localizations.dart';
import 'package:trackless/pages/work_dialog/work_dialog.dart';
import 'package:trackless/trackless/models/trackless_work_model.dart';

/// A item for listWork
class ListWorkItem extends StatelessWidget {
  final TracklessWork work;

  ListWorkItem({Key key, this.work}) : super(key: key);

  final listItemKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: listItemKey,
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
      // Ontap: work dialog
      onTap: () {
        // Create an animation
        Navigator.push(
            context,
            MorpheusPageRoute(
                builder: (_) => WorkDialog(work),
                parentKey: listItemKey,
                transitionColor: Theme.of(context).scaffoldBackgroundColor));
      },
    );
  }
}
