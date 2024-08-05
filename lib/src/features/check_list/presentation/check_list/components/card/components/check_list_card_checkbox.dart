import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/check_list/presentation/check_list/components/card/check_list_card_controller.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckListCardCheckbox extends ConsumerWidget {
  const CheckListCardCheckbox({
    super.key,
    required this.taskInstance,
    required this.color,
  });

  final TaskInstance taskInstance;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dateRepositoryProvider).date;
    final state = ref.watch(checkListCardControllerProvider(taskInstance));

    bool isEnabled = !date.isAfter(getDateNoTimeToday());

    return state.isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          )
        : Checkbox(
            value: taskInstance.completed,
            onChanged: isEnabled
                ? (bool? value) {
                    ref
                        .watch(checkListCardControllerProvider(taskInstance)
                            .notifier)
                        .toggleComplete();
                  }
                : null,
            activeColor: color,
          );
  }
}
