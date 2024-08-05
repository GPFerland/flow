import 'dart:async';

import 'package:flow/src/features/check_list/data/task_display_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/notifier_mounted.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_list_controller.g.dart';

@riverpod
class CheckListController extends _$CheckListController with NotifierMounted {
  @override
  FutureOr<void> build() {
    ref.onDispose(setUnmounted);
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
}
