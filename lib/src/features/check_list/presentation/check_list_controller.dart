import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/check_list/data/task_visibility_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckListController extends StateNotifier<AsyncValue<void>> {
  CheckListController({
    required this.taskVisibilityRepository,
    required this.dateRepository,
    required this.tasksService,
    required this.taskInstancesService,
  }) : super(const AsyncData(null));

  final TaskVisibilityRepository taskVisibilityRepository;
  final DateRepository dateRepository;
  final TasksService tasksService;
  final TaskInstancesService taskInstancesService;

  List<TaskInstance> sortTaskInstances(List<TaskInstance> taskInstances) {
    taskInstances.sort(
      (a, b) {
        // 1. Primary Sort: Outstanding, Completed, Skipped
        if (!a.skipped && !a.completed && (b.skipped || b.completed)) {
          return -1; // a (outstanding) comes before b
        } else if (a.completed && !a.skipped && b.skipped) {
          return -1; // a (completed) comes before b (skipped)
        } else if (!b.skipped && !b.completed && (a.skipped || a.completed)) {
          return 1; // b (outstanding) comes before a
        } else if (b.completed && !b.skipped && a.skipped) {
          return 1; // b (completed) comes before a (skipped)
        } else {
          // 2. Secondary Sort: Task Priority (within each section)
          return a.taskPriority.compareTo(b.taskPriority);
        }
      },
    );
    if (taskVisibilityRepository.taskVisibility == TaskVisibility.outstanding) {
      taskInstances.removeWhere(
        (taskInstance) {
          if (taskInstance.completed || taskInstance.skipped) {
            return true;
          }
          return false;
        },
      );
    }
    return taskInstances;
  }

  Future<void> toggleVisibility() async {
    final visibility = taskVisibilityRepository.taskVisibility;
    await taskVisibilityRepository.setVisibility(
      visibility == TaskVisibility.all
          ? TaskVisibility.outstanding
          : TaskVisibility.all,
    );
  }

  Future<void> rescheduleTaskInstance({
    required DateTime newDate,
    required TaskInstance taskInstance,
    required VoidCallback onRescheduled,
  }) async {
    state = const AsyncLoading();
    final updatedTaskInstance = taskInstance.reschedule(newDate);
    final value = await AsyncValue.guard(
      () => taskInstancesService.setTaskInstance(updatedTaskInstance),
    );
    // * only set the state if the controller hasn't been disposed
    if (mounted) {
      if (value.hasError) {
        state = AsyncError(value.error!, StackTrace.current);
      } else {
        state = value;
        onRescheduled();
      }
    }
  }

  Future<void> skipTaskInstance({
    required TaskInstance taskInstance,
    required VoidCallback onSkipped,
  }) async {
    state = const AsyncLoading();
    final updatedTaskInstance = taskInstance.toggleSkipped(dateRepository.date);
    final value = await AsyncValue.guard(
      () => taskInstancesService.setTaskInstance(updatedTaskInstance),
    );
    // * only set the state if the controller hasn't been disposed
    if (mounted) {
      if (value.hasError) {
        state = AsyncError(value.error!, StackTrace.current);
      } else {
        state = value;
        onSkipped();
      }
    }
  }

  Future<void> deleteTask({
    required TaskInstance taskInstance,
    required VoidCallback onDelete,
  }) async {
    state = const AsyncLoading();
    final value = await AsyncValue.guard(() async {
      // * attempt to delete the task instances associated with the task
      await taskInstancesService.removeTasksInstances(taskInstance.taskId);
      // * attempt to delete the task
      await tasksService.removeTask(taskInstance.taskId);
    });
    // * only set the state if the controller hasn't been disposed
    if (mounted) {
      if (value.hasError) {
        state = AsyncError(value.error!, StackTrace.current);
      } else {
        state = value;
        onDelete();
      }
    }
  }
}

final checkListControllerProvider =
    StateNotifierProvider.autoDispose<CheckListController, AsyncValue<void>>(
  (ref) {
    return CheckListController(
      taskVisibilityRepository: ref.watch(taskVisibilityRepositoryProvider),
      dateRepository: ref.watch(dateRepositoryProvider),
      tasksService: ref.watch(tasksServiceProvider),
      taskInstancesService: ref.watch(taskInstancesServiceProvider),
    );
  },
);
