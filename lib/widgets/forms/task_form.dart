import 'package:flow/data/models/routine.dart';
import 'package:flow/data/models/task.dart';
import 'package:flow/data/providers/models/routines_provider.dart';
import 'package:flow/data/providers/models/tasks_provider.dart';
import 'package:flow/utils/date.dart';
import 'package:flow/utils/style.dart';
import 'package:flow/widgets/buttons/delete_icon_button.dart';
import 'package:flow/widgets/dividers/divider_on_primary_container.dart';
import 'package:flow/widgets/input_fields/color/color_input_field.dart';
import 'package:flow/widgets/input_fields/icon/icon_input_field.dart';
import 'package:flow/widgets/forms/form_utils.dart';
import 'package:flow/widgets/forms/monthly_task_fields.dart';
import 'package:flow/widgets/forms/one_time_task_fields.dart';
import 'package:flow/widgets/forms/weekly_task_fields.dart';
import 'package:flow/widgets/input_fields/dropdown/routine_dropdown_field.dart';
import 'package:flow/widgets/input_fields/text/description_input_field.dart';
import 'package:flow/widgets/input_fields/text/title_input_field.dart';
import 'package:flow/widgets/input_fields/toggle/until_complete_toggle_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskForm extends ConsumerStatefulWidget {
  const TaskForm({
    super.key,
    required this.mode,
    this.task,
  });

  final FormMode mode;
  final Task? task;

  @override
  ConsumerState<TaskForm> createState() {
    return _TaskFormState();
  }
}

class _TaskFormState extends ConsumerState<TaskForm>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _titleKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _descriptionKey = GlobalKey<FormFieldState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedRoutine;
  String? _selectedRoutineId;

  IconData? _selectedIcon;
  Color? _selectedColor;

  Frequency _frequency = Frequency.once;
  late Map<String, bool> _selectedWeekDays;
  late List<Map<String, dynamic>> _selectedMonthDays;
  DateTime _selectedDate = getDateNoTime(DateTime.now());

  bool? _untilCompleted;

  late TabController _taskTypeTabController;

  @override
  void initState() {
    super.initState();
    int tabIndex = 0;
    if (widget.mode == FormMode.editing && widget.task != null) {
      _titleController.text = widget.task!.title!;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedRoutine = widget.task!.routineId != null
          ? ref
              .read(routinesProvider.notifier)
              .getRoutineTitleFromId(widget.task!.routineId!)
          : null;
      _selectedRoutineId = widget.task!.routineId;
      _selectedIcon = widget.task!.icon;
      _selectedColor = widget.task!.color;
      _frequency = widget.task!.frequency!;
      _selectedDate = widget.task!.selectedDate!;
      _selectedWeekDays = sortDaysMap(widget.task!.selectedWeekdays!);
      _selectedMonthDays = widget.task!.selectedMonthDays!;
      _untilCompleted = widget.task!.showUntilCompleted ?? true;
      tabIndex = Frequency.values.indexOf(widget.task!.frequency!);
    } else if (widget.mode == FormMode.creating) {
      _selectedWeekDays = {for (var day in shorthandWeekdays) day: false};
      _selectedMonthDays = List.empty(growable: true);
      _selectedIcon = Icons.task_alt;
      _untilCompleted = true;
    }
    _taskTypeTabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: tabIndex,
    );
    _taskTypeTabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _taskTypeTabController.dispose();
    super.dispose();
  }

  void _selectRoutine(
    String? selectedRoutine,
    String? selectedRoutineId,
  ) {
    setState(() {
      _selectedRoutine = selectedRoutine;
      _selectedRoutineId = selectedRoutineId;
    });
  }

  void _selectDate(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void _selectColor(BuildContext _, Color? selectedColor) {
    setState(() {
      _selectedColor = selectedColor;
    });
  }

  void _selectIcon(IconData? selectedIcon) {
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
    if (_taskTypeTabController.indexIsChanging) {
      setState(() {
        _frequency = Frequency.values[_taskTypeTabController.index];
      });
    }
  }

  void _saveTask() {
    if (_form.currentState!.validate()) {
      Task task = Task(
        title: _titleController.text,
        icon: _selectedIcon,
        color: _selectedColor!,
        frequency: _frequency,
        description: _descriptionController.text,
        routineId: _selectedRoutineId,
        selectedDate: _selectedDate,
        selectedWeekdays: _selectedWeekDays,
        selectedMonthDays: _selectedMonthDays,
        showUntilCompleted: _untilCompleted,
      );

      if (widget.task != null) {
        task.setId(widget.task!.id!);
        task.setPriority(widget.task!.priority!);
      }

      if (widget.mode == FormMode.creating) {
        ref.read(tasksProvider.notifier).createTask(
              task,
              context,
            );
      } else if (widget.mode == FormMode.editing) {
        ref.read(tasksProvider.notifier).updateTask(
              task,
              context,
            );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Routine> routines = ref.watch(routinesProvider);

    _selectedColor ??= Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Form(
        key: _form,
        child: Column(
          children: [
            if (widget.mode == FormMode.editing)
              Row(
                children: [
                  const SizedBox(
                    width: 54,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Edit Task',
                        style: getTitleLargeOnPrimaryContainer(context),
                      ),
                    ),
                  ),
                  DeleteIconButton(item: widget.task!),
                ],
              ),
            if (widget.mode == FormMode.editing)
              const DividerOnPrimaryContainer(),
            Row(
              children: [
                Expanded(
                  child: TitleInputField(
                    titleKey: _titleKey,
                    titleController: _titleController,
                  ),
                ),
                IconInputField(
                  selectIcon: _selectIcon,
                  selectedIcon: _selectedIcon,
                  selectedColor: _selectedColor,
                ),
                ColorInputField(
                  selectColor: _selectColor,
                  selectedColor: _selectedColor,
                ),
              ],
            ),
            RoutineDropdownField(
              selectedRoutine: _selectedRoutine,
              selectRoutine: _selectRoutine,
              routines: routines,
            ),
            DescriptionInputField(
              descriptionKey: _descriptionKey,
              descriptionController: _descriptionController,
            ),
            UntilCompletedToggleSlider(
              untilCompleted: _untilCompleted ?? true,
              updateUntilCompleted: _updateUntilCompleted,
            ),
            Card(
              margin: const EdgeInsets.all(0),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Theme.of(context).colorScheme.primary,
                    dividerColor: Theme.of(context).colorScheme.onPrimary,
                    controller: _taskTypeTabController,
                    tabs: [
                      Tab(
                        child: Text(
                          'One-time',
                          style: _taskTypeTabController.index == 0
                              ? getBodyMediumOnPrimaryContainer(context)
                              : getBodySmallOnPrimaryContainer(context),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Weekly',
                          style: _taskTypeTabController.index == 1
                              ? getBodyMediumOnPrimaryContainer(context)
                              : getBodySmallOnPrimaryContainer(context),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Monthly',
                          style: _taskTypeTabController.index == 2
                              ? getBodyMediumOnPrimaryContainer(context)
                              : getBodySmallOnPrimaryContainer(context),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: [
                      OneTimeTaskFields(
                        selectedDate: _selectedDate,
                        selectDate: _selectDate,
                      ),
                      WeeklyTaskFields(
                        selectedWeekDays: _selectedWeekDays,
                      ),
                      MonthlyTaskFields(
                        selectedMonthDays: _selectedMonthDays,
                      ),
                    ][_taskTypeTabController.index],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: getTitleMediumOnPrimary(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
