import 'package:flow/src/common_widgets/buttons/primary_button.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/task/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskCreateOrUpdateButton extends ConsumerWidget {
  const TaskCreateOrUpdateButton({
    super.key,
    required this.task,
    required this.submitTask,
  });

  final Task? task;
  final void Function() submitTask;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskControllerProvider);

    return PrimaryButton(
      text: task == null ? 'Create' : 'Update',
      isLoading: state.isLoading,
      onPressed: state.isLoading ? null : submitTask,
    );
  }
}
