import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/task_instances_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SkipTaskButton extends ConsumerWidget {
  const SkipTaskButton({
    super.key,
    required this.taskInstance,
    required this.date,
  });

  final TaskInstance taskInstance;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      child: const Text('Skip Task'),
      onPressed: () {
        taskInstance.skipped = true;
        taskInstance.skippedDate = date;
        ref.read(taskInstancesProvider.notifier).updateItem(
              taskInstance,
              //context,
            );
        Navigator.pop(context);
      },
    );
  }
}
