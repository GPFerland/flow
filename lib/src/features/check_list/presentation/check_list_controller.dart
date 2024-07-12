import 'package:flow/src/features/check_list/data/task_visibility_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckListController extends StateNotifier<AsyncValue<void>> {
  CheckListController({
    required this.visibilityRepository,
  }) : super(const AsyncData(null));

  final TaskVisibilityRepository visibilityRepository;

  List<TaskInstance> sortTaskInstances(List<TaskInstance> taskInstances) {
    taskInstances.sort(
      (a, b) {
        if (!a.skipped && !a.completed) {
          // a is neither skipped nor completed (highest priority)
          return -1; // a comes before b
        } else if (!a.completed && b.completed) {
          // a is completed, b is not (a comes before b)
          return -1;
        } else if (!a.skipped && b.skipped) {
          // a is not skipped, b is skipped (a comes before b)
          return -1;
        } else {
          // Other cases: both skipped, both completed, or a skipped and b completed
          return 1; // a comes after b
        }
      },
    );
    if (visibilityRepository.taskVisibility == TaskVisibility.outstanding) {
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
    final visibility = visibilityRepository.taskVisibility;
    await visibilityRepository.setVisibility(
      visibility == TaskVisibility.all
          ? TaskVisibility.outstanding
          : TaskVisibility.all,
    );
  }
}

final checkListControllerProvider =
    StateNotifierProvider.autoDispose<CheckListController, AsyncValue<void>>(
  (ref) {
    return CheckListController(
        visibilityRepository: ref.watch(
      taskVisibilityRepositoryProvider,
    ));
  },
);
