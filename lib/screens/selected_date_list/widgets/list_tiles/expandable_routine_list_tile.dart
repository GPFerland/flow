import 'package:flow/models/routine.dart';
import 'package:flow/providers/date/selected_date_provider.dart';
import 'package:flow/providers/models/routines_provider.dart';
import 'package:flow/utils/style.dart';
import 'package:flow/widgets/dividers/divider_routine.dart';
import 'package:flow/widgets/list_tile_components/routine_list_tile_components/routine_list_tile_expandable_icon.dart';
import 'package:flow/widgets/list_tile_components/routine_list_tile_components/routine_list_tile_icon.dart';
import 'package:flow/widgets/list_tile_components/routine_list_tile_components/routine_list_tile_subtitle.dart';
import 'package:flow/widgets/list_tile_components/routine_list_tile_components/routine_list_tile_title.dart';
import 'package:flow/modals/edit_routine_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpandableRoutineListTile extends ConsumerStatefulWidget {
  const ExpandableRoutineListTile({
    super.key,
    required this.routine,
    this.disable = false,
  });

  final Routine routine;
  final bool disable;

  @override
  ConsumerState<ExpandableRoutineListTile> createState() {
    return _ExpandableRoutineListTileState();
  }
}

class _ExpandableRoutineListTileState
    extends ConsumerState<ExpandableRoutineListTile> {
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = ref.read(selectedDateProvider);

    bool completed = widget.routine.tasks!.every(
      (task) => task.isComplete(selectedDate),
    );

    return Column(
      children: [
        InkWell(
          onTap: widget.disable
              ? null
              : () {
                  ref.read(routinesProvider.notifier).toggleRoutineExpanded(
                        widget.routine,
                        context,
                      );
                },
          onLongPress: widget.disable
              ? null
              : () {
                  showEditRoutineModal(
                    context: context,
                    routine: widget.routine,
                  );
                },
          child: Container(
            height: listTileHeight,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: completed ? widget.routine.color!.withOpacity(0.1) : null,
            ),
            child: Row(
              children: [
                RoutineListTileIcon(routine: widget.routine),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoutineListTileTitle(routine: widget.routine),
                      RoutineListTaskSubtitle(
                        routine: widget.routine,
                        date: selectedDate,
                        completed: completed,
                      ),
                    ],
                  ),
                ),
                AnimatedExpandIcon(
                  key: UniqueKey(),
                  isExpanded: widget.routine.isExpanded!,
                ),
                const SizedBox(
                  width: 12,
                )
              ],
            ),
          ),
        ),
        if (widget.routine.isExpanded!)
          DividerForRoutine(routine: widget.routine),
      ],
    );
  }
}
