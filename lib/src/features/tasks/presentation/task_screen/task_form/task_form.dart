import 'package:flow/src/common_widgets/buttons/primary_button.dart';
import 'package:flow/src/common_widgets/input_fields/color/color_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/icon/icon_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/text/description_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/text/title_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/toggle/until_complete_toggle_slider.dart';
import 'package:flow/src/common_widgets/responsive_scrollable_card.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/task_controller.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/task_form/task_frequency_fields/daily_task_fields.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/task_form/task_frequency_fields/monthly_task_fields.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/task_form/task_frequency_fields/once_task_fields.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/task_form/task_frequency_fields/weekly_task_fields.dart';
import 'package:flow/src/utils/async_value_ui.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class TaskForm extends ConsumerStatefulWidget {
  const TaskForm({
    super.key,
    this.task,
  });

  final Task? task;

  // * Keys for testing using find.byKey()
  static const taskTitleKey = Key('taskTitle');
  static const taskIconKey = Key('taskIcon');
  static const taskColorKey = Key('taskColor');
  static const taskDescriptionKey = Key('taskDescription');
  static const taskUntilCompletedKey = Key('taskUntilCompleted');

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
  late FrequencyType _frequencyType;
  late DateTime _date;
  late List<Weekday> _weekdays;
  late List<Monthday> _monthdays;
  late TabController _frequencyTypeTabController;

  @override
  void initState() {
    super.initState();
    int tabIndex = 0;
    final task = widget.task;
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _icon = task.icon;
      _color = task.color;
      _untilCompleted = task.untilCompleted;
      _frequencyType = task.frequencyType;
      _date = task.date;
      _weekdays = task.weekdays;
      _monthdays = task.monthdays;
      tabIndex = FrequencyType.values.indexOf(task.frequencyType);
    } else {
      _icon = Icons.check;
      _color = Colors.blue.shade200;
      _untilCompleted = true;
      _frequencyType = FrequencyType.once;
      _date = getDateNoTimeToday();
      _weekdays = [];
      _monthdays = [];
    }
    _frequencyTypeTabController = TabController(
      length: FrequencyType.values.length,
      vsync: this,
      initialIndex: tabIndex,
    );
    _frequencyTypeTabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _frequencyTypeTabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_frequencyTypeTabController.indexIsChanging) {
      setState(() {
        _frequencyType =
            FrequencyType.values[_frequencyTypeTabController.index];
      });
    }
  }

  void _selectColor(BuildContext _, Color selectedColor) {
    setState(() {
      _color = selectedColor;
    });
  }

  void _selectIcon(IconData selectedIcon) {
    setState(() {
      _icon = selectedIcon;
    });
  }

  void _updateUntilCompleted(bool untilCompleted) {
    setState(() {
      _untilCompleted = untilCompleted;
    });
  }

  void _selectDate(DateTime selectedDate) {
    setState(() {
      _date = selectedDate;
    });
  }

  void _selectWeekdays(List<Weekday> selectedWeekdays) {
    setState(() {
      _weekdays = selectedWeekdays;
    });
  }

  void _selectMonthdays(List<Monthday> selectedMonthdays) {
    setState(() {
      _monthdays = selectedMonthdays;
    });
  }

  void _submitTask() async {
    //setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final oldTask = widget.task;
      Task task = Task(
        id: oldTask != null ? oldTask.id : const Uuid().v4(),
        title: _titleController.text,
        icon: _icon,
        color: _color,
        description: _descriptionController.text,
        createdOn: oldTask != null ? oldTask.createdOn : getDateNoTimeToday(),
        untilCompleted: _untilCompleted,
        frequencyType: _frequencyType,
        date: _date,
        weekdays: _weekdays,
        monthdays: _monthdays,
      );

      ref.read(taskFormControllerProvider.notifier).submitTask(
            task: task,
            oldTask: oldTask,
            onSuccess: context.pop,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      taskFormControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(taskFormControllerProvider);

    return ResponsiveScrollableCard(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TitleInputField(
                    titleKey: TaskForm.taskTitleKey,
                    titleController: _titleController,
                    readOnly: state.isLoading,
                  ),
                ),
                IconInputField(
                  iconKey: TaskForm.taskIconKey,
                  selectIcon: _selectIcon,
                  selectedIcon: _icon,
                  selectedColor: _color,
                  readOnly: state.isLoading,
                ),
                ColorInputField(
                  colorKey: TaskForm.taskColorKey,
                  selectColor: _selectColor,
                  selectedColor: _color,
                  readOnly: state.isLoading,
                ),
              ],
            ),
            DescriptionInputField(
              descriptionKey: TaskForm.taskDescriptionKey,
              descriptionController: _descriptionController,
              readOnly: state.isLoading,
            ),
            UntilCompletedToggleSlider(
              untilCompletedKey: TaskForm.taskUntilCompletedKey,
              untilCompleted: _untilCompleted,
              updateUntilCompleted: _updateUntilCompleted,
              readOnly: state.isLoading,
            ),
            Card(
              child: Column(
                children: [
                  TabBar(
                    // labelColor: Theme.of(context).colorScheme.primary,
                    // dividerColor: Theme.of(context).colorScheme.onPrimary,
                    controller: _frequencyTypeTabController,
                    tabs: FrequencyType.values.map((frequencyType) {
                      return Tab(
                        key: frequencyType.tabKey,
                        child: Text(
                          frequencyType.shorthand,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      );
                    }).toList(),
                  ),
                  Center(
                    child: [
                      OnceTaskFields(
                        selectedDate: _date,
                        selectDate: _selectDate,
                      ),
                      const DailyTaskFields(),
                      WeeklyTaskFields(
                        selectedWeekdays: _weekdays,
                        selectWeekdays: _selectWeekdays,
                      ),
                      MonthlyTaskFields(
                        selectedMonthdays: _monthdays,
                        selectMonthdays: _selectMonthdays,
                      ),
                    ][_frequencyTypeTabController.index],
                  )
                ],
              ),
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
