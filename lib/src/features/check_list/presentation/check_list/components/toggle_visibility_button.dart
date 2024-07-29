import 'package:flow/src/features/check_list/data/task_visibility_repository.dart';
import 'package:flow/src/features/check_list/presentation/check_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleVisibilityButton extends ConsumerWidget {
  const ToggleVisibilityButton({super.key});

  // * Keys for testing using find.byKey()
  static const toggleVisibilityKey = Key('toggleVisibility');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibility = ref.watch(taskVisibilityStateChangesProvider).value;

    return TextButton(
      key: toggleVisibilityKey,
      onPressed: () {
        ref.read(checkListControllerProvider.notifier).toggleVisibility();
      },
      child: Text(
        visibility == TaskVisibility.all ? 'hide completed' : 'show all',
      ),
    );
  }
}
