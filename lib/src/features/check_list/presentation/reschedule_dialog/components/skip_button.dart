import 'package:flow/src/common_widgets/buttons/primary_button.dart';
import 'package:flow/src/features/check_list/presentation/check_list_controller.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SkipButton extends ConsumerWidget {
  const SkipButton({
    super.key,
    required this.taskInstance,
  });

  final TaskInstance taskInstance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkListControllerProvider);

    void onSkipped() {
      context.pop();
    }

    return PrimaryButton(
      text: taskInstance.skipped ? 'Un-skip'.hardcoded : 'Skip'.hardcoded,
      isLoading: state.isLoading,
      onPressed: () {
        ref.read(checkListControllerProvider.notifier).skipTaskInstance(
              taskInstance: taskInstance,
              onSkipped: onSkipped,
            );
      },
    );
  }
}
