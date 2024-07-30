import 'package:flow/src/utils/in_memory_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_display_repository.g.dart';

enum TaskDisplay {
  all, // show all of the tasks, outstanding, completed, and skipped
  outstanding, // only show outstanding tasks
}

class TaskDisplayRepository {
  TaskDisplayRepository();

  final _taskDisplayState = InMemoryStore<TaskDisplay>(TaskDisplay.all);

  Stream<TaskDisplay> taskDisplayStateChanges() => _taskDisplayState.stream;
  TaskDisplay get taskDisplay => _taskDisplayState.value;

  void _setTaskDisplay(TaskDisplay taskDisplay) {
    _taskDisplayState.value = taskDisplay;
  }

  Future<void> setDisplay(TaskDisplay taskDisplay) async {
    _setTaskDisplay(taskDisplay);
  }

  void dispose() => _taskDisplayState.close();
}

@Riverpod(keepAlive: true)
TaskDisplayRepository taskDisplayRepository(TaskDisplayRepositoryRef ref) {
  final taskDisplayRepository = TaskDisplayRepository();
  ref.onDispose(() => taskDisplayRepository.dispose());
  return taskDisplayRepository;
}

@Riverpod(keepAlive: true)
Stream<TaskDisplay> taskDisplayStream(TaskDisplayStreamRef ref) {
  final taskDisplayRepository = ref.watch(taskDisplayRepositoryProvider);
  return taskDisplayRepository.taskDisplayStateChanges();
}
