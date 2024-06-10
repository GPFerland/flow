import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/routines_provider.dart';
import 'package:flow/src/features/routines/presentation/reorderable_routine_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReorderableRoutineList extends ConsumerWidget {
  const ReorderableRoutineList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Routine> routines = ref.watch(routinesProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ReorderableListView.builder(
        shrinkWrap: true,
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
          final int adjustedIndex =
              newIndex > oldIndex ? newIndex - 1 : newIndex;
          routines.insert(adjustedIndex, movedRoutine);

          for (int i = 0; i < routines.length; i++) {
            routines[i].setPriority(i);
          }

          ref.read(routinesProvider.notifier).updateRoutines(routines, context);
        },
        proxyDecorator: (Widget child, int index, Animation<double> animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Material(
                elevation: 8 * Curves.easeInOut.transform(animation.value),
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).cardColor,
                child: child!,
              );
            },
            child: child,
          );
        },
      ),
    );
  }
}
