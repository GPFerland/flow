import 'package:flow/models/task.dart';
import 'package:flow/widgets/forms/reschedule_task_form.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

Future showScheduleTaskModal({
  required BuildContext context,
  required Task task,
  required DateTime date,
}) {
  SliverWoltModalSheetPage scheduleTaskPage = WoltModalSheetPage(
    hasTopBarLayer: false,
    child: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 0, 6),
            child: ScheduleTaskForm(
              task: task,
              date: date,
            ),
          ),
        ],
      ),
    ),
  );

  return WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (modalSheetContext) {
      return [
        scheduleTaskPage,
      ];
    },
    modalTypeBuilder: (context) {
      return WoltModalType.dialog;
    },
    onModalDismissedWithBarrierTap: () {
      debugPrint('Closed modal sheet with barrier tap');
      Navigator.of(context).pop();
    },
  );
}
