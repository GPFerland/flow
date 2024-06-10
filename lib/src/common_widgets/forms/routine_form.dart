import 'package:flow/src/features/routines/domain/routine.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/routines_provider.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flow/src/common_widgets/buttons/delete_icon_button.dart';
import 'package:flow/src/common_widgets/dividers/divider_on_primary_container.dart';
import 'package:flow/src/common_widgets/input_fields/color/color_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/icon/icon_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/text/description_input_field.dart';
import 'package:flow/src/common_widgets/input_fields/text/title_input_field.dart';
import 'package:flow/src/common_widgets/forms/form_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutineForm extends ConsumerStatefulWidget {
  const RoutineForm({
    super.key,
    required this.mode,
    this.routine,
  });

  final FormMode mode;
  final Routine? routine;

  @override
  ConsumerState<RoutineForm> createState() {
    return _RoutineFormState();
  }
}

class _RoutineFormState extends ConsumerState<RoutineForm> {
  final _form = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _titleKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _descriptionKey = GlobalKey<FormFieldState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  IconData? _selectedIcon;
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    if (widget.mode == FormMode.editing && widget.routine != null) {
      _titleController.text = widget.routine!.title!;
      _descriptionController.text = widget.routine!.description ?? '';
      _selectedIcon = widget.routine!.icon;
      _selectedColor = widget.routine!.color;
    } else {
      _selectedIcon = Icons.route;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  void _saveRoutine() {
    if (_form.currentState!.validate()) {
      Routine routine = Routine(
        title: _titleController.text,
        icon: _selectedIcon,
        color: _selectedColor!,
        description: _descriptionController.text,
      );

      if (widget.routine != null) {
        routine.setId(widget.routine!.id!);
        routine.setPriority(widget.routine!.priority!);
      }

      if (widget.mode == FormMode.creating) {
        ref.read(routinesProvider.notifier).createRoutine(
              routine,
              context,
            );
      } else if (widget.mode == FormMode.editing) {
        ref.read(routinesProvider.notifier).updateRoutine(
              routine,
              context,
            );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        'Edit Routine',
                        style: getTitleLargeOnPrimaryContainer(context),
                      ),
                    ),
                  ),
                  DeleteIconButton(item: widget.routine!),
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
            DescriptionInputField(
              descriptionKey: _descriptionKey,
              descriptionController: _descriptionController,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveRoutine,
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
