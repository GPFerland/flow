import 'package:flow/src/features/tasks/presentation/task/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskTitleInputField extends ConsumerStatefulWidget {
  const TaskTitleInputField({
    super.key,
    required this.titleController,
  });

  final TextEditingController titleController;

  // * Keys for testing using find.byKey()
  static const taskTitleKey = Key('taskTitle');

  @override
  ConsumerState<TaskTitleInputField> createState() =>
      _TaskTitleInputFieldState();
}

class _TaskTitleInputFieldState extends ConsumerState<TaskTitleInputField> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskControllerProvider);

    return TextFormField(
      key: TaskTitleInputField.taskTitleKey,
      controller: widget.titleController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please add a title.';
        }
        return null;
      },
      readOnly: state.isLoading,
    );
  }
}
