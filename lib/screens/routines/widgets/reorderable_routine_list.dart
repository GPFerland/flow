import 'package:flow/models/routine.dart';
import 'package:flow/providers/models/routines_provider.dart';
import 'package:flow/screens/routines/widgets/reorderable_routine_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReorderableRoutineList extends ConsumerWidget {
  const ReorderableRoutineList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Routine> routines = ref.watch(routinesProvider);

    return ReorderableListView.builder(
      itemCount: routines.length,
      itemBuilder: (context, index) {
        return ReorderableRoutineListTile(
          key: ValueKey(routines[index].id),
          routine: routines[index],
        );
      },
      onReorder: (oldIndex, newIndex) {
        //todo - I think this is duplicated in the routines list and could be in
        // a function or something?????
        final Routine movedRoutine = routines.removeAt(oldIndex);
        final int adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
        routines.insert(adjustedIndex, movedRoutine);

        for (int i = 0; i < routines.length; i++) {
          routines[i].setPriority(i);
        }

        ref.read(routinesProvider.notifier).updateRoutines(routines, context);
      },
    );
  }
}
