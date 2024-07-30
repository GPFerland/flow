import 'package:flow/src/features/check_list/data/task_display_repository.dart';
import 'package:flow/src/features/check_list/presentation/check_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleDisplayButton extends ConsumerWidget {
  const ToggleDisplayButton({super.key});

  // * Keys for testing using find.byKey()
  static const toggleDisplayKey = Key('toggleVisibility');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(taskDisplayStreamProvider).value;

    return TextButton(
      key: toggleDisplayKey,
      onPressed: () {
        ref.read(checkListControllerProvider.notifier).toggleDisplay();
      },
      child: Text(
        display == TaskDisplay.all ? 'hide completed' : 'show all',
      ),
    );
  }
}
