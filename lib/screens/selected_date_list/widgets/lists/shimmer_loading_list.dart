import 'package:flow/models/routine.dart';
import 'package:flow/models/task.dart';
import 'package:flow/screens/selected_date_list/widgets/list_tiles/checkable_task_list_tile.dart';
import 'package:flow/screens/selected_date_list/widgets/list_tiles/expandable_routine_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingList extends StatelessWidget {
  const ShimmerLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    final Task fakeTask = Task(
      title: 'tasks loading...',
      icon: Icons.refresh,
      color: Theme.of(context).colorScheme.primary,
    );

    final Routine fakeRoutine = Routine(
      title: 'routines loading...',
      icon: Icons.refresh,
      color: Theme.of(context).colorScheme.primary,
      isExpanded: false,
      tasks: [fakeTask],
    );

    return ListView.builder(
      itemCount: 12,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
          highlightColor:
              Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5),
          child: index.isEven
              ? CheckableTaskListTile(
                  task: fakeTask,
                  disable: true,
                )
              : ExpandableRoutineListTile(
                  routine: fakeRoutine,
                  disable: true,
                ),
        );
      },
    );
  }
}
