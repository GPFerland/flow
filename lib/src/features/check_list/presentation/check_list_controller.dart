import 'dart:async';

import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/check_list/data/task_display_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_list_controller.g.dart';

@riverpod
class CheckListController extends _$CheckListController {
  Object? mounted;

  @override
  FutureOr<void> build() {
    mounted = Object();
    ref.onDispose(() => mounted = null);
    // no initialization work to do
  }

  List<TaskInstance> sortTaskInstances(List<TaskInstance> taskInstances) {
    final taskDisplayRepository = ref.read(taskDisplayRepositoryProvider);
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
    if (taskDisplayRepository.taskDisplay == TaskDisplay.outstanding) {
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

  Future<void> toggleDisplay() async {
    final taskDisplayRepository = ref.read(taskDisplayRepositoryProvider);
    final visibility = taskDisplayRepository.taskDisplay;
    await taskDisplayRepository.setDisplay(
      visibility == TaskDisplay.all ? TaskDisplay.outstanding : TaskDisplay.all,
    );
  }

  Future<void> rescheduleTaskInstance({
    required DateTime newDate,
    required TaskInstance taskInstance,
    required VoidCallback onRescheduled,
  }) async {
    final taskInstancesService = ref.read(taskInstancesServiceProvider);
    state = const AsyncLoading();
    final mounted = this.mounted;
    final updatedTaskInstance = taskInstance.reschedule(newDate);
    final value = await AsyncValue.guard(
      () => taskInstancesService.setTaskInstances([updatedTaskInstance]),
    );
    // * only set the state if the controller hasn't been disposed
    if (mounted == this.mounted) {
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
    final dateRepository = ref.read(dateRepositoryProvider);
    final taskInstancesService = ref.read(taskInstancesServiceProvider);

    state = const AsyncLoading();
    final mounted = this.mounted;
    final updatedTaskInstance = taskInstance.toggleSkipped(dateRepository.date);
    final value = await AsyncValue.guard(
      () => taskInstancesService.setTaskInstances([updatedTaskInstance]),
    );
    // * only set the state if the controller hasn't been disposed
    if (mounted == this.mounted) {
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
    final tasksService = ref.read(tasksServiceProvider);
    final taskInstancesService = ref.read(taskInstancesServiceProvider);

    state = const AsyncLoading();
    final mounted = this.mounted;
    final value = await AsyncValue.guard(() async {
      // * attempt to delete the task instances associated with the task
      await taskInstancesService.removeTasksInstances(taskInstance.taskId);
      // * attempt to delete the task
      await tasksService.removeTask(taskInstance.taskId);
    });
    // * only set the state if the controller hasn't been disposed
    if (mounted == this.mounted) {
      if (value.hasError) {
        state = AsyncError(value.error!, StackTrace.current);
      } else {
        state = value;
        onDelete();
      }
    }
  }
}
