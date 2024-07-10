import 'package:flow/src/features/tasks/presentation/task_screen/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//todo - this does not work because the icons are not included in the deployment
class TaskIconInputField extends ConsumerStatefulWidget {
  const TaskIconInputField({
    super.key,
    required this.icon,
    required this.color,
    required this.updateIcon,
  });

  final IconData icon;
  final Color color;
  final void Function(IconData) updateIcon;

  // * Keys for testing using find.byKey()
  static const taskIconKey = Key('taskIcon');

  @override
  ConsumerState<TaskIconInputField> createState() => _TaskIconInputFieldState();
}

class _TaskIconInputFieldState extends ConsumerState<TaskIconInputField> {
  late IconData icon;

  @override
  void initState() {
    super.initState();
    icon = widget.icon;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskControllerProvider);

    return GestureDetector(
      key: TaskIconInputField.taskIconKey,
      onTap: state.isLoading
          ? null
          : () async {
              IconData? newIcon = await showIconPicker(
                context,
                iconColor: widget.color,
                title: const Text('Select Icon'),
              );
              if (newIcon != null && newIcon != icon) {
                setState(() {
                  icon = newIcon;
                  widget.updateIcon(icon);
                });
              }
            },
      child: Container(
        height: 44,
        width: 44,
        margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 36,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
