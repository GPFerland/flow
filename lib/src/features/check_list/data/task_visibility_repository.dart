import 'package:flow/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskVisibility {
  all, // show all of the tasks, outstanding, completed, and skipped
  outstanding, // only shouw outstanding tasks
}

class TaskVisibilityRepository {
  TaskVisibilityRepository();

  final _taskVisibilityState =
      InMemoryStore<TaskVisibility>(TaskVisibility.all);

  Stream<TaskVisibility> taskVisibilityStateChanges() =>
      _taskVisibilityState.stream;
  TaskVisibility get taskVisibility => _taskVisibilityState.value;

  void _setTaskVisibility(TaskVisibility taskVisibility) {
    _taskVisibilityState.value = taskVisibility;
  }

  Future<void> setVisibility(TaskVisibility taskVisibility) async {
    _setTaskVisibility(taskVisibility);
  }

  void dispose() => _taskVisibilityState.close();
}

final taskVisibilityRepositoryProvider = Provider<TaskVisibilityRepository>(
  (ref) {
    final taskVisibilityRepository = TaskVisibilityRepository();
    ref.onDispose(() => taskVisibilityRepository.dispose());
    return taskVisibilityRepository;
  },
);

final taskVisibilityStateChangesProvider = StreamProvider<TaskVisibility>(
  (ref) {
    final taskVisibilityRepository =
        ref.watch(taskVisibilityRepositoryProvider);
    return taskVisibilityRepository.taskVisibilityStateChanges();
  },
);
