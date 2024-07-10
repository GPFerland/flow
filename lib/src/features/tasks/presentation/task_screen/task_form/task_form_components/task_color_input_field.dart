import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flow/src/features/tasks/presentation/task_screen/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskColorInputField extends ConsumerWidget {
  const TaskColorInputField({
    super.key,
    required this.color,
    required this.updateColor,
  });

  final Color color;
  final void Function(Color) updateColor;

  // * Keys for testing using find.byKey()
  static const taskColorKey = Key('taskColor');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskControllerProvider);

    Color tempColor = color;

    return GestureDetector(
      key: taskColorKey,
      onTap: state.isLoading
          ? null
          : () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: AlertDialog(
                      contentPadding: const EdgeInsets.all(4),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 4,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Select Color',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      updateColor(tempColor);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check),
                                  ),
                                ],
                              ),
                            ),
                            ColorPicker(
                              padding: const EdgeInsets.only(
                                top: 0,
                                left: 6,
                                right: 6,
                                bottom: 6,
                              ),
                              color: tempColor,
                              onColorChanged: (Color newColor) {
                                tempColor = newColor;
                              },
                              subheading: Text(
                                'Select color shade',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              width: 44,
                              height: 44,
                              borderRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
      child: Container(
        height: 44,
        width: 44,
        margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            width: 2.0,
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
