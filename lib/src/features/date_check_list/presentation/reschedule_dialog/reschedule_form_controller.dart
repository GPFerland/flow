import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RescheduleFormController extends StateNotifier<AsyncValue<void>> {
  RescheduleFormController({required this.taskInstancesService})
      : super(const AsyncData(null));
  final TaskInstancesService taskInstancesService;

  Future<bool> rescheduleTaskInstance(
    TaskInstance taskInstance,
    DateTime rescheduledDate,
  ) async {
    state = const AsyncLoading<void>();
    final updatedTaskInstance = taskInstance.reschedule(rescheduledDate);
    final value = await AsyncValue.guard(
      () => taskInstancesService.setTaskInstance(updatedTaskInstance),
    );
    if (value.hasValue && !value.hasError) {
      return true;
    }
    state = value;
    return state.hasError == false;
  }

  Future<bool> skipTaskInstance(TaskInstance taskInstance) async {
    state = const AsyncLoading<void>();
    final updatedTaskInstance = taskInstance.toggleSkipped();
    final value = await AsyncValue.guard(
      () => taskInstancesService.setTaskInstance(updatedTaskInstance),
    );
    if (value.hasValue && !value.hasError) {
      return true;
    }
    state = value;
    return state.hasError == false;
  }
}

final rescheduleFormControllerProvider = StateNotifierProvider.autoDispose<
    RescheduleFormController, AsyncValue<void>>(
  (ref) {
    return RescheduleFormController(
      taskInstancesService: ref.watch(taskInstancesServiceProvider),
    );
  },
);
