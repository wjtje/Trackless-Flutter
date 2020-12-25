import 'package:flutter/material.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:trackless/app_localizations.dart';
import 'package:trackless/trackless/models/trackless_work_model.dart';

/// A item for listWork
class ListWorkItem extends StatelessWidget {
  final TracklessWork work;

  const ListWorkItem({Key key, this.work}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: (work != null)
          ? Text(work.location.place + ' - ' + work.location.name)
          : SkeletonText(
              height: 12,
              padding: 1,
            ),
      subtitle: (work != null)
          ? Text(work.description)
          : SkeletonText(
              height: 10,
              padding: 1,
            ),
      trailing: (work != null)
          ? Text(
              '${work.time.toString()} ${AppLocalizations.of(context).translate('list_work_hour')}')
          : Skeleton(
              style: SkeletonStyle.text,
              height: 12,
              padding: 1,
              width: 80,
            ),
      onTap: () {},
    );
  }
}
