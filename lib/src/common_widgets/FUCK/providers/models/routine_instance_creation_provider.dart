import 'package:flow/src/features/routine_instances/domain/routine_instance.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/routine_instances_provider.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/task_instances_provider.dart';
import 'package:flow/src/common_widgets/FUCK/providers/models/tasks_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routineInstanceCreationProvider =
    Provider<RoutineInstanceCreationService>(
  (ref) => RoutineInstanceCreationService(ref: ref),
);

class RoutineInstanceCreationService {
  RoutineInstanceCreationService({
    required this.ref,
  });

  final ProviderRef ref;

  Future<void> createMissingInstances(DateTime date) async {
    // for (RoutineInstance routineInstance
    //     in ref.read(routineInstancesProvider)) {
    //   routineInstance.taskInstances ??= [];
    //   if (routineInstance.taskInstanceIds != null) {
    //     for (String id in routineInstance.taskInstanceIds!) {
    //       TaskInstance? taskInstance =
    //           ref.read(taskInstancesProvider.notifier).getTaskInstanceById(id);
    //       if (taskInstance != null) {
    //         routineInstance.taskInstances!.add(taskInstance);
    //         await ref
    //             .read(routineInstancesProvider.notifier)
    //             .updateRoutineInstance(
    //               routineInstance,
    //               //context,
    //             );
    //       }
    //     }
    //   }
    // }

    final List<Task> tasks = ref.read(tasksProvider);

    for (Task task in tasks) {
      if (!task.isScheduled(date)) {
        DateTime? previousDate = task.getPreviousScheduledDate(date);
        if (previousDate == null) {
          continue;
        }
        TaskInstance? previousTaskInstance =
            ref.read(taskInstancesProvider.notifier).getTaskInstance(
                  task.id!,
                  previousDate,
                );
        if (previousTaskInstance == null) {
          continue;
        }

        if (previousTaskInstance.rescheduledDate == date ||
            (!previousTaskInstance.completed && task.showUntilCompleted!)) {
          await _createMissingRoutineInstance(previousTaskInstance, date, ref);
        }
        continue;
      }

      TaskInstance? taskInstance = ref
          .read(taskInstancesProvider.notifier)
          .getTaskInstance(task.id!, date);

      if (taskInstance == null) {
        TaskInstance newTaskInstance = TaskInstance(
          taskId: task.id!,
          taskPriority: task.priority!,
          routineId: task.routineId,
          initialDate: date,
        );
        await ref.read(taskInstancesProvider.notifier).createTaskInstance(
              newTaskInstance,
              //context,
            );
        taskInstance = newTaskInstance;
      }

      if (taskInstance.routineId == null) {
        continue;
      }

      await _createMissingRoutineInstance(taskInstance, date, ref);
    }

    await Future.delayed(const Duration(milliseconds: 2000));
  }

  //todo - this function name is shitty
  Future<void> _createMissingRoutineInstance(
    TaskInstance taskInstance,
    DateTime date,
    ProviderRef ref,
  ) async {
    if (taskInstance.routineId == null) {
      return;
    }

    RoutineInstance? matchingRoutineInstance =
        ref.read(routineInstancesProvider.notifier).getRoutineInstance(
              taskInstance.routineId!,
              date,
            );

    if (matchingRoutineInstance != null) {
      matchingRoutineInstance.taskInstances ??= [];
      matchingRoutineInstance.taskInstanceIds ??= [];
      if (!matchingRoutineInstance.taskInstances!.contains(taskInstance)) {
        matchingRoutineInstance.taskInstances!.add(taskInstance);
      }
      if (!matchingRoutineInstance.taskInstanceIds!.contains(taskInstance.id)) {
        matchingRoutineInstance.taskInstanceIds!.add(taskInstance.id!);
        await ref.read(routineInstancesProvider.notifier).updateRoutineInstance(
              matchingRoutineInstance,
              //context,
            );
      }

      return;
    }

    RoutineInstance newRoutineInstance = RoutineInstance(
      routineId: taskInstance.routineId!,
      date: date,
      taskInstanceIds: [taskInstance.id!],
      taskInstances: [taskInstance],
    );
    await ref.read(routineInstancesProvider.notifier).createRoutineInstance(
          newRoutineInstance,
          //context,
        );
  }
}
