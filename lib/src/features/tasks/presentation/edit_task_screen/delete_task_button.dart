import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_form_controller.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> onDeletePressed() async {
      ref.read(taskFormControllerProvider.notifier).deleteTaskInstances(task);
      ref.read(taskFormControllerProvider.notifier).deleteTask(task);
      context.pop(true);
    }

    ref.listen<AsyncValue>(
      taskFormControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(taskFormControllerProvider);

    return IconButton(
      icon: const Icon(Icons.delete),
      iconSize: 28,
      onPressed: state.isLoading
          ? null
          : () {
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
                                onPressed: () {
                                  context.pop(false);
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: onDeletePressed,
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).then((value) {
                if (value == true) {
                  context.pop();
                }
              });
            },
    );
  }
}
