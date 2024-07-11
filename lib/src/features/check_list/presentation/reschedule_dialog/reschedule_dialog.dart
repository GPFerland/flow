import 'package:flow/src/features/check_list/presentation/reschedule_dialog/reschedule_form.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flutter/material.dart';

const kRescheduleDialogKey = Key('rescheduleDialogKey');

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showRescheduleDialog({
  required BuildContext context,
  required TaskInstance taskInstance,
}) async {
  return showDialog(
    context: context,
    // * AlertDialog.adaptive was added in Flutter 3.13
    builder: (context) => AlertDialog.adaptive(
      key: kRescheduleDialogKey,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      title: const Center(
        child: Text('Reschedule Task'),
      ),
      content: RescheduleForm(
        taskInstance: taskInstance,
      ),
    ),
  );
}
