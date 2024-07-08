import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/task_controller.dart';
import 'package:flow/src/utils/async_value_ui.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeleteTaskButton extends ConsumerWidget {
  const DeleteTaskButton({
    super.key,
    required this.task,
  });

  final Task task;

  // * Keys for testing using find.byKey()
  static const deleteTaskIconButtonKey = Key('deleteTaskIconButton');
  static const deleteTaskDialogButtonKey = Key('deleteTaskDialogButton');
  static const cancelDialogButtonKey = Key('cancelDialogButton');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> onDeleteDialogButtonPressed() async {
      ref.read(taskFormControllerProvider.notifier).deleteTasksInstances(
            task: task,
            onSuccess: () {},
          );
      ref.read(taskFormControllerProvider.notifier).deleteTask(
            task: task,
            onSuccess: context.pop,
          );
      context.pop();
    }

    Future<void> showDeleteDialog() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(Sizes.p16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Confirm',
                    style: getTitleLargeOnPrimaryContainer(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                  gapH16,
                  Text(
                    'Delete ${(task).title}',
                    textAlign: TextAlign.center,
                    style: getBodyLargeOnPrimaryContainer(context),
                  ),
                  gapH24,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      OutlinedButton(
                        key: cancelDialogButtonKey,
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        key: deleteTaskDialogButtonKey,
                        onPressed: onDeleteDialogButtonPressed,
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    ref.listen<AsyncValue>(
      taskFormControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(taskFormControllerProvider);

    return IconButton(
      key: deleteTaskIconButtonKey,
      icon: const Icon(Icons.delete),
      iconSize: 28,
      onPressed: state.isLoading ? null : () => showDeleteDialog(),
    );
  }
}
