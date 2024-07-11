import 'package:flow/src/features/tasks/presentation/task/task_controller.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flow/src/common_widgets/input_fields/input_fields_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskDescriptionInputField extends ConsumerStatefulWidget {
  const TaskDescriptionInputField({
    super.key,
    required this.descriptionController,
  });

  final TextEditingController descriptionController;

  static const taskDescriptionKey = Key('taskDescription');

  @override
  ConsumerState<TaskDescriptionInputField> createState() =>
      _DescriptionInputFieldState();
}

class _DescriptionInputFieldState
    extends ConsumerState<TaskDescriptionInputField> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskControllerProvider);

    return TextFormField(
      key: TaskDescriptionInputField.taskDescriptionKey,
      controller: widget.descriptionController,
      decoration: getTextInputFieldDecoration(
        labelText: 'Description',
        context: context,
      ),
      style: getTitleSmallOnPrimaryContainer(context),
      cursorHeight: cursorHeight,
      readOnly: state.isLoading,
    );
  }
}
