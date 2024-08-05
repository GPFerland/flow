import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/check_list/presentation/check_list/components/reschedule_dialog/components/delete_button.dart';
import 'package:flow/src/features/check_list/presentation/check_list/components/reschedule_dialog/components/reschedule_button.dart';
import 'package:flow/src/features/check_list/presentation/check_list/components/reschedule_dialog/components/skip_button.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';

const kRescheduleDialogKey = Key('rescheduleDialogKey');

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showRescheduleDialog({
  required BuildContext context,
  required TaskInstance taskInstance,
}) async {
  List<Widget> actionButtons = List.empty(growable: true);

  if (taskInstance.nextScheduledDate != getDateNoTimeTomorrow()) {
    actionButtons.add(RescheduleButton(taskInstance: taskInstance));
    actionButtons.add(gapH12);
  }

  if (taskInstance.nextScheduledDate == null) {
    actionButtons.add(DeleteButton(taskInstance: taskInstance));
  } else {
    actionButtons.add(SkipButton(taskInstance: taskInstance));
  }

  return showDialog(
    context: context,
    // * AlertDialog.adaptive was added in Flutter 3.13
    builder: (context) => AlertDialog.adaptive(
      key: kRescheduleDialogKey,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...actionButtons,
        ],
      ),
    ),
  );
}
