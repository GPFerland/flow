import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksService {
  TasksService({
    required this.authRepository,
    required this.localTasksRepository,
    required this.remoteTasksRepository,
  });

  final TestAuthRepository authRepository;
  final LocalTasksRepository localTasksRepository;
  final RemoteTasksRepository remoteTasksRepository;

  /// save the tasks to the local or remote repository
  /// depending on the user auth state
  Future<void> _setTasks(List<Task> tasks) async {
    final user = authRepository.currentUser;
    if (user == null) {
      return await localTasksRepository.setTasks(tasks);
    }
    await remoteTasksRepository.setTasks(user.uid, tasks);
  }

  /// fetch the tasks from the local or remote repository
  /// depending on the user auth state
  Future<List<Task>> _fetchTasks() {
    final user = authRepository.currentUser;
    if (user == null) {
      return localTasksRepository.fetchTasks();
    }
    return remoteTasksRepository.fetchTasks(user.uid);
  }

  /// sets a task in the local or remote repository
  /// depending on the user auth state
  Future<void> setTask(Task task) async {
    final tasks = await _fetchTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);

    if (index == -1) {
      tasks.add(task);
    } else {
      tasks[index] = task;
    }

    await _setTasks(tasks);
  }

  /// fetch tasks from the local or remote repository
  /// depending on the user auth state
  Future<List<Task>> fetchTasks() async {
    return await _fetchTasks();
  }

  /// removes a task from the local or remote repository
  /// depending on the user auth state
  Future<void> removeTask(String taskId) async {
    final tasks = await _fetchTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await _setTasks(tasks);
  }
}

final tasksServiceProvider = Provider<TasksService>(
  (ref) {
    return TasksService(
      authRepository: ref.watch(
        authRepositoryProvider,
      ),
      localTasksRepository: ref.watch(
        localTasksRepositoryProvider,
      ),
      remoteTasksRepository: ref.watch(
        remoteTasksRepositoryProvider,
      ),
    );
  },
);

final tasksStreamProvider = StreamProvider.autoDispose<List<Task>>(
  (ref) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user == null) {
      return ref.watch(localTasksRepositoryProvider).watchTasks();
    }
    return ref.watch(remoteTasksRepositoryProvider).watchTasks(user.uid);
  },
);

final taskFutureProvider = FutureProvider.autoDispose.family<Task?, String>(
  (ref, taskId) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user == null) {
      return ref.watch(localTasksRepositoryProvider).fetchTask(taskId);
    }
    return ref.watch(remoteTasksRepositoryProvider).fetchTask(user.uid, taskId);
  },
);

final taskStreamProvider = StreamProvider.autoDispose.family<Task?, String>(
  (ref, taskId) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user == null) {
      return ref.watch(localTasksRepositoryProvider).watchTask(taskId);
    }
    return ref.watch(remoteTasksRepositoryProvider).watchTask(user.uid, taskId);
  },
);
