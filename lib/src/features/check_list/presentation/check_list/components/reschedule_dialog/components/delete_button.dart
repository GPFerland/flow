import 'package:flow/src/common_widgets/buttons/primary_button.dart';
import 'package:flow/src/features/check_list/presentation/check_list/components/card/check_list_card_controller.dart';
import 'package:flow/src/features/check_list/presentation/check_list_controller.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeleteButton extends ConsumerWidget {
  const DeleteButton({
    super.key,
    required this.taskInstance,
  });

  final TaskInstance taskInstance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkListControllerProvider);

    return PrimaryButton(
      text: 'Delete'.hardcoded,
      isLoading: state.isLoading,
      onPressed: () {
        ref
            .read(checkListCardControllerProvider(taskInstance).notifier)
            .deleteTask();
        context.pop();
      },
    );
  }
}
