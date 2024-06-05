import 'package:flow/data/models/routine.dart';
import 'package:flow/features/edit_routine/edit_routine_modal.dart';
import 'package:flow/widgets/list_card_components/routine_list_card_components/routine_list_card_icon.dart';
import 'package:flow/widgets/list_card_components/routine_list_card_components/routine_list_card_title.dart';
import 'package:flutter/material.dart';

class ReorderableRoutineListTile extends StatelessWidget {
  const ReorderableRoutineListTile({
    super.key,
    required this.routine,
  });

  final Routine routine;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        showEditRoutineModal(
          context: context,
          routine: routine,
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              RoutineListCardIcon(
                routine: routine,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: RoutineListCardTitle(
                  routine: routine,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
