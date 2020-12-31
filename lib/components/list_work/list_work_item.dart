import 'package:flutter/material.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:trackless/app_localizations.dart';
import 'package:trackless/pages/work_dialog/work_dialog.dart';
import 'package:trackless/trackless/models/trackless_work_model.dart';

/// A item for listWork
class ListWorkItem extends StatelessWidget {
  final TracklessWork work;

  const ListWorkItem({Key key, this.work}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Title: location
      title: (work != null)
          ? Text(work.location.fullName)
          : SkeletonText(
              height: 12,
              padding: 1,
            ),
      // Subtitle: Description
      subtitle: (work != null)
          ? Text(work.description)
          : SkeletonText(
              height: 10,
              padding: 1,
            ),
      // Trailing: Time
      trailing: (work != null)
          ? Text(
              '${work.time.toString()} ${AppLocalizations.of(context).translate('list_work_hour')}')
          : Skeleton(
              style: SkeletonStyle.text,
              height: 12,
              padding: 1,
              width: 80,
            ),
      // Ontap: work dialog
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => WorkDialog(work)));
      },
    );
  }
}
