import 'package:flow/src/common_widgets/buttons/primary_button.dart';
import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/check_list/presentation/check_list/components/card/check_list_card_controller.dart';
import 'package:flow/src/features/check_list/presentation/check_list_controller.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RescheduleButton extends ConsumerWidget {
  const RescheduleButton({
    super.key,
    required this.taskInstance,
  });

  final TaskInstance taskInstance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkListControllerProvider);

    return PrimaryButton(
      text: 'Reschedule'.hardcoded,
      isLoading: state.isLoading,
      onPressed: () async {
        DateTime currentDate = ref.read(dateRepositoryProvider).date;

        DateTime? newDate = await selectDate(
          context: context,
          initialDate: currentDate,
          firstDate: taskInstance.scheduledDate,
          lastDate: taskInstance.nextScheduledDate?.subtract(
            const Duration(days: 1),
          ),
        );

        if (newDate == null || newDate == currentDate) {
          return;
        }

        ref
            .read(checkListCardControllerProvider(taskInstance).notifier)
            .rescheduleTaskInstance(
              newDate: newDate,
            );
        if (context.mounted) {
          context.pop();
        }
      },
    );
  }
}
