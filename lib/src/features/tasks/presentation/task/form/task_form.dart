import 'package:flow/src/common_widgets/buttons/primary_button.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/task_color_input_field.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/task_icon_input_field.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/task_description_input_field.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/task_title_input_field.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/task_until_complete_switch.dart';
import 'package:flow/src/common_widgets/responsive_scrollable_card.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/task/task_controller.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/frequency/task_frequency_tabs.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class TaskForm extends ConsumerStatefulWidget {
  const TaskForm({super.key, this.task});

  final Task? task;

  @override
  ConsumerState<TaskForm> createState() {
    return _TaskFormState();
  }
}

class _TaskFormState extends ConsumerState<TaskForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late IconData _icon;
  late Color _color;
  late bool _untilCompleted;
  late Frequency _frequency;
  late DateTime _date;
  late List<Weekday> _weekdays;
  late List<Monthday> _monthdays;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _icon = task.icon;
      _color = task.color;
      _untilCompleted = task.untilCompleted;
      _frequency = task.frequency;
      _date = task.date.copyWith();
      _weekdays = List.from(task.weekdays);
      _monthdays = List.from(task.monthdays);
    } else {
      _icon = Icons.check;
      _color = Colors.blue.shade200;
      _untilCompleted = true;
      _frequency = Frequency.once;
      _date = getDateNoTimeToday();
      _weekdays = [];
      _monthdays = [];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateColor(Color color) => setState(() => _color = color);
  void _updateIcon(IconData icon) => _icon = icon;
  void _updateUntilCompleted(bool untilCompleted) =>
      _untilCompleted = untilCompleted;
  void _updateFrequency(Frequency frequency) => _frequency = frequency;
  void _updateDate(DateTime date) => _date = date;
  void _updateWeekdays(List<Weekday> weekdays) => _weekdays = weekdays;
  void _updateMonthdays(List<Monthday> monthdays) => _monthdays = monthdays;

  void _submitTask() async {
    //setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final oldTask = widget.task;
      Task task = Task(
        id: oldTask != null ? oldTask.id : const Uuid().v4(),
        priority: oldTask != null ? oldTask.priority : 0,
        title: _titleController.text,
        icon: _icon,
        color: _color,
        description: _descriptionController.text,
        createdOn: oldTask != null ? oldTask.createdOn : getDateNoTimeToday(),
        untilCompleted: _untilCompleted,
        frequency: _frequency,
        date: _date,
        weekdays: _weekdays,
        monthdays: _monthdays,
      );

      ref.read(taskControllerProvider.notifier).submitTask(
            task: task,
            oldTask: oldTask,
            onSuccess: context.pop,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskControllerProvider);

    return ResponsiveScrollableCard(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TaskTitleInputField(
                    titleController: _titleController,
                  ),
                ),
                TaskIconInputField(
                  updateIcon: _updateIcon,
                  icon: _icon,
                  color: _color,
                ),
                TaskColorInputField(
                  updateColor: _updateColor,
                  color: _color,
                ),
              ],
            ),
            TaskDescriptionInputField(
              descriptionController: _descriptionController,
            ),
            TaskUntilCompletedSwitch(
              untilCompleted: _untilCompleted,
              updateUntilCompleted: _updateUntilCompleted,
            ),
            TaskFrequencyTabs(
              frequency: _frequency,
              updateFrequency: _updateFrequency,
              date: _date,
              updateDate: _updateDate,
              weekdays: _weekdays,
              updateWeekdays: _updateWeekdays,
              monthdays: _monthdays,
              updateMonthdays: _updateMonthdays,
            ),
            gapH8,
            PrimaryButton(
              text: widget.task == null ? 'Create' : 'Update',
              isLoading: state.isLoading,
              onPressed: state.isLoading ? null : _submitTask,
            ),
          ],
        ),
      ),
    );
  }
}
