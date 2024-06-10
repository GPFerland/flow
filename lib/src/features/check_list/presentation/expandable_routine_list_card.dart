import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/features/routine_instances/domain/routine_instance.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/routine_instances_provider.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/routines_provider.dart';
import 'package:flow/src/features/routines/presentation/edit_routine_modal.dart';
import 'package:flow/src/common_widgets/list_card_components/routine_list_card_components/routine_list_card_expandable_icon.dart';
import 'package:flow/src/common_widgets/list_card_components/routine_list_card_components/routine_list_card_icon.dart';
import 'package:flow/src/common_widgets/list_card_components/routine_list_card_components/routine_list_card_subtitle.dart';
import 'package:flow/src/common_widgets/list_card_components/routine_list_card_components/routine_list_card_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpandableRoutineListCard extends ConsumerWidget {
  const ExpandableRoutineListCard({
    super.key,
    required this.routineInstance,
    required this.selectedDate,
  });

  final RoutineInstance routineInstance;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Routine? routine = ref
        .read(routinesProvider.notifier)
        .getRoutineFromId(routineInstance.routineId);
    bool completed = routineInstance.taskInstances != null
        ? routineInstance.taskInstances!.every(
            (taskInstance) => taskInstance.completed,
          )
        : true;
    final Color? cardColor = completed || routineInstance.isExpanded
        ? routine!.color?.withOpacity(0.2)
        : null;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        routineInstance.toggleExpanded();
        ref.read(routineInstancesProvider.notifier).updateItem(
              routineInstance,
              //context,
            );
      },
      onLongPress: () {
        showEditRoutineModal(
          context: context,
          routine: routine,
        );
      },
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Row(
            children: [
              RoutineListCardIcon(routine: routine!),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoutineListCardTitle(routine: routine),
                    RoutineListCardSubtitle(
                      routineInstance: routineInstance,
                      date: selectedDate,
                      completed: completed,
                    ),
                  ],
                ),
              ),
              AnimatedExpandIcon(
                key: UniqueKey(),
                isExpanded: routineInstance.isExpanded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
