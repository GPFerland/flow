import 'package:flow/src/common_widgets/FUCK/providers/models/routine_instances_provider.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/routines_provider.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/task_instances_provider.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/tasks_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskAndRoutineFutureProvider = FutureProvider<void>((ref) async {
  await ref.read(tasksProvider.notifier).getTasks();
  await ref.read(routinesProvider.notifier).getRoutines();
  await ref.read(taskInstancesProvider.notifier).getTaskInstances();
  await ref.read(routineInstancesProvider.notifier).getRoutineInstances();

  await Future.delayed(const Duration(milliseconds: 2000));
});
