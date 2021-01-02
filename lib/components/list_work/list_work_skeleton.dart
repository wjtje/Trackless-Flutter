import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:trackless/components/list_work/list_work_header.dart';

import 'list_work_item.dart';

class ListWorkSkeleton extends StatelessWidget {
  const ListWorkSkeleton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: ListWorkHeader(),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => () {
                  // First one
                  if (index == 0) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        ListWorkItem(),
                        Divider(),
                      ],
                    );
                  } else if ((index + 1) != 10) {
                    return Column(
                      children: [
                        ListWorkItem(),
                        Divider(),
                      ],
                    );
                  } else {
                    // Last one
                    return Column(
                      children: [
                        ListWorkItem(),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    );
                  }
                }(),
            childCount: 10),
      ),
    );
  }
}
