import 'package:flow/data/models/routine.dart';
import 'package:flow/data/providers/models/routines_provider.dart';
import 'package:flow/features/edit_routine/edit_routine_modal.dart';
import 'package:flow/widgets/list_card_components/routine_list_card_components/routine_list_card_expandable_icon.dart';
import 'package:flow/widgets/list_card_components/routine_list_card_components/routine_list_card_icon.dart';
import 'package:flow/widgets/list_card_components/routine_list_card_components/routine_list_card_subtitle.dart';
import 'package:flow/widgets/list_card_components/routine_list_card_components/routine_list_card_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpandableRoutineListCard extends ConsumerWidget {
  const ExpandableRoutineListCard({
    super.key,
    required this.routine,
    required this.selectedDate,
  });

  final Routine routine;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool completed = routine.tasks!.every(
      (task) => task.isComplete(selectedDate),
    );
    final Color? cardColor = completed || routine.isExpanded!
        ? routine.color?.withOpacity(0.2)
        : null;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        ref.read(routinesProvider.notifier).toggleRoutineExpanded(
              routine,
              context,
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
              RoutineListCardIcon(routine: routine),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoutineListCardTitle(routine: routine),
                    RoutineListCardSubtitle(
                      routine: routine,
                      date: selectedDate,
                      completed: completed,
                    ),
                  ],
                ),
              ),
              AnimatedExpandIcon(
                key: UniqueKey(),
                isExpanded: routine.isExpanded!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
