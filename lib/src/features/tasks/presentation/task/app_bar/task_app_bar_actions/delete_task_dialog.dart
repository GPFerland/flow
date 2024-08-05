import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/presentation/task/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeleteTaskDialog extends ConsumerWidget {
  const DeleteTaskDialog({
    super.key,
    required this.taskId,
  });

  final String taskId;

  // keys for testing used for find.byKey()
  static const deleteTaskIconButtonKey = Key('deleteTaskIconButton');
  static const deleteTaskDialogButtonKey = Key('deleteTaskDialogButton');
  static const cancelDialogButtonKey = Key('cancelDialogButton');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            gapH16,
            const Text('Are you sure?'),
            gapH24,
            TextButton(
              key: deleteTaskDialogButtonKey,
              onPressed: () {
                ref.read(taskControllerProvider.notifier).deleteTask(
                      taskId: taskId,
                    );
                context.pop();
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
