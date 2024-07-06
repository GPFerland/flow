import 'package:flow/src/common_widgets/input_fields/color/color_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/icon/icon_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/text/description_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/text/title_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/toggle/until_complete_toggle_slider.dart';
import 'package:flow/src/common_widgets/buttons/primary_button.dart';
import 'package:flow/src/common_widgets/responsive_scrollable_card.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/date_check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_form_controller.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_frequency_fields/daily_task_fields.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_frequency_fields/monthly_task_fields.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_frequency_fields/once_task_fields.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_frequency_fields/weekly_task_fields.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flow/src/utils/async_value_ui.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

//todo - I think there is a lot of logic in here that could be moved to the controller
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

  late IconData _selectedIcon;
  late Color _selectedColor;

  late bool _untilCompleted;

  late FrequencyType _frequencyType;
  late DateTime _selectedDate;
  late List<Weekday> _selectedWeekdays;
  late List<Monthday> _selectedMonthdays;
  late TabController _frequencyTypeTabController;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  //bool _submitted = false;

  @override
  void initState() {
    super.initState();
    int tabIndex = 0;
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedIcon = widget.task!.icon;
      _selectedColor = widget.task!.color;
      _untilCompleted = widget.task!.showUntilCompleted;
      _frequencyType = widget.task!.frequencyType;
      _selectedDate = widget.task!.date;
      _selectedWeekdays = widget.task!.weekdays;
      _selectedMonthdays = widget.task!.monthdays;
      tabIndex = FrequencyType.values.indexOf(widget.task!.frequencyType);
    } else {
      _selectedIcon = Icons.check;
      _selectedColor = Colors.blue.shade200;
      _untilCompleted = true;
      _frequencyType = FrequencyType.once;
      _selectedDate = getDateNoTimeToday();
      _selectedWeekdays = [];
      _selectedMonthdays = [];
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

  void _selectColor(BuildContext _, Color selectedColor) {
    setState(() {
      _selectedColor = selectedColor;
    });
  }

  void _selectIcon(IconData selectedIcon) {
    setState(() {
      _selectedIcon = selectedIcon;
    });
  }

  void _updateUntilCompleted(bool untilCompleted) {
    setState(() {
      _untilCompleted = untilCompleted;
    });
  }

  void _handleTabSelection() {
    if (_frequencyTypeTabController.indexIsChanging) {
      setState(() {
        _frequencyType =
            FrequencyType.values[_frequencyTypeTabController.index];
      });
    }
  }

  void _selectDate(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void _selectWeekdays(List<Weekday> selectedWeekdays) {
    setState(() {
      _selectedWeekdays = selectedWeekdays;
    });
  }

  void _selectMonthdays(List<Monthday> selectedMonthdays) {
    setState(() {
      _selectedMonthdays = selectedMonthdays;
    });
  }

  void _submitTask() async {
    //setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      Task task = Task(
        id: widget.task != null ? widget.task!.id : const Uuid().v4(),
        title: _titleController.text,
        icon: _selectedIcon,
        color: _selectedColor,
        description: _descriptionController.text,
        createdOn: getDateNoTimeToday(),
        showUntilCompleted: _untilCompleted,
        frequencyType: _frequencyType,
        date: _selectedDate,
        weekdays: _selectedWeekdays,
        monthdays: _selectedMonthdays,
      );

      final controller = ref.read(taskFormControllerProvider.notifier);
      final success = await controller.submitTask(task);
      if (success) {
        DateTime date = ref.read(dateRepositoryProvider).date;
        await ref.read(taskInstancesServiceProvider).createTaskInstance(
              task,
              date.subtract(const Duration(days: 1)),
            );
        await ref.read(taskInstancesServiceProvider).createTaskInstance(
              task,
              date,
            );
        await ref.read(taskInstancesServiceProvider).createTaskInstance(
              task,
              date.add(const Duration(days: 1)),
            );
        //todo - I dont love this and its hard to test
        if (mounted) {
          context.goNamed(AppRoute.tasks.name);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      taskFormControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(taskFormControllerProvider);

    _selectedColor = Theme.of(context).colorScheme.primary;

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
                  selectedIcon: _selectedIcon,
                  selectedColor: _selectedColor,
                  readOnly: state.isLoading,
                ),
                ColorInputField(
                  colorKey: TaskForm.taskColorKey,
                  selectColor: _selectColor,
                  selectedColor: _selectedColor,
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
                        selectedDate: _selectedDate,
                        selectDate: _selectDate,
                      ),
                      const DailyTaskFields(),
                      WeeklyTaskFields(
                        selectedWeekdays: _selectedWeekdays,
                        selectWeekdays: _selectWeekdays,
                      ),
                      MonthlyTaskFields(
                        selectedMonthdays: _selectedMonthdays,
                        selectMonthdays: _selectMonthdays,
                      ),
                    ][_frequencyTypeTabController.index],
                  )
                ],
              ),
            ),
            gapH8,
            PrimaryButton(
              text: 'Submit',
              isLoading: state.isLoading,
              onPressed: _submitTask,
            ),
          ],
        ),
      ),
    );
  }
}
