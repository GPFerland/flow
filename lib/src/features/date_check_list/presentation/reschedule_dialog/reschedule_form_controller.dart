import 'package:flow/src/features/date_check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RescheduleFormController extends StateNotifier<AsyncValue<DateTime>> {
  RescheduleFormController({
    required this.taskInstancesService,
    required this.initialDate,
  }) : super(AsyncData(initialDate));
  final TaskInstancesService taskInstancesService;
  final DateTime initialDate;

  Future<void> selectRescheduledDate({required BuildContext context}) async {
    // DateTime firstDate = getDateNoTime(DateTime.now());
    // firstDate =
    //     firstDate.isBefore(rescheduledDate!) ? firstDate : rescheduledDate!;

    // DateTime? lastDate = widget.task.getNextScheduledDate(rescheduledDate!);
    // lastDate = lastDate.subtract(
    //   const Duration(days: 1),
    // );

    DateTime? newDate = await selectDate(
      context: context,
      initialDate: state.value!,
      //firstDate: firstDate,
      //lastDate: lastDate,
    );

    if (newDate != null) {
      state = AsyncData(newDate);
    }
  }

  Future<void> rescheduleTaskInstance(TaskInstance taskInstance) async {
    //final rescheduledDate = state.value!;
    state = const AsyncLoading<DateTime>().copyWithPrevious(state);
    final updatedTaskInstance = taskInstance.reschedule(state.value!);
    final value = await AsyncValue.guard(
      () => taskInstancesService.setTaskInstance(updatedTaskInstance),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    }
  }

  Future<void> skipTaskInstance(TaskInstance taskInstance) async {
    state = const AsyncLoading<DateTime>().copyWithPrevious(state);
    final updatedTaskInstance = taskInstance.toggleSkipped(initialDate);
    final value = await AsyncValue.guard(
      () => taskInstancesService.setTaskInstance(updatedTaskInstance),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    }
  }
}

final rescheduleFormControllerProvider = StateNotifierProvider.autoDispose<
    RescheduleFormController, AsyncValue<DateTime>>(
  (ref) {
    return RescheduleFormController(
      taskInstancesService: ref.watch(taskInstancesServiceProvider),
      initialDate: ref.watch(dateRepositoryProvider).date,
    );
  },
);
