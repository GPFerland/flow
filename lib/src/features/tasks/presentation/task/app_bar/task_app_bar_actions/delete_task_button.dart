import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/presentation/task/app_bar/task_app_bar_actions/delete_task_dialog.dart';
import 'package:flow/src/features/tasks/presentation/task/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteTaskButton extends ConsumerWidget {
  const DeleteTaskButton({
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
    final state = ref.watch(taskControllerProvider);

    Future<void> showDeleteDialog() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteTaskDialog(taskId: taskId);
        },
      );
    }

    return IconButton(
      key: deleteTaskIconButtonKey,
      icon: const Icon(Icons.delete),
      iconSize: 28,
      onPressed: state.isLoading ? null : () => showDeleteDialog(),
    );
  }
}
