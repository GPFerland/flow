import 'package:flow/models/task.dart';
import 'package:flow/widgets/forms/form_utils.dart';
import 'package:flow/widgets/forms/task_form.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

Future showEditTaskModal({
  required BuildContext context,
  required Task task,
}) {
  SliverWoltModalSheetPage taskPage = WoltModalSheetPage(
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
            child: TaskForm(
              mode: FormMode.editing,
              task: task,
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
        taskPage,
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
