import 'package:flow/src/features/date_check_list/presentation/reschedule_dialog/reschedule_form.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flutter/material.dart';

const kDialogDefaultKey = Key('dialog-default-key');

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showRescheduleDialog({
  required BuildContext context,
  required TaskInstance taskInstance,
}) async {
  return showDialog(
    context: context,
    // * AlertDialog.adaptive was added in Flutter 3.13
    builder: (context) => AlertDialog.adaptive(
      title: const Text('Reschedule Task'),
      content: RescheduleForm(
        taskInstance: taskInstance,
      ),
    ),
  );
}
