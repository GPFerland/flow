import 'package:flow/models/task.dart';
import 'package:flow/widgets/list_tiles/task_list_tiles/checkable_task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingList extends StatelessWidget {
  const ShimmerLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 12,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
          highlightColor:
              Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.2),
          child: CheckableTaskListTile(
            task: Task(
              title: 'loading...',
              icon: Icons.new_releases,
              color: Theme.of(context).colorScheme.primary,
            ),
            isCheckable: false,
          ),
        );
      },
    );
  }
}
