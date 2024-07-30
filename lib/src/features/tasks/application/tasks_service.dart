import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/mutable_task.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_service.g.dart';

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
      await localTasksRepository.setTasks(
        tasks,
      );
    } else {
      await remoteTasksRepository.setTasks(
        user.uid,
        tasks,
      );
    }
  }

  /// fetch the tasks from the local or remote repository
  /// depending on the user auth state
  Future<List<Task>> _fetchTasks() {
    final user = authRepository.currentUser;
    if (user == null) {
      return localTasksRepository.fetchTasks();
    } else {
      return remoteTasksRepository.fetchTasks(user.uid);
    }
  }

  /// sets a list of tasks
  Future<void> setTasks(List<Task> tasks) async {
    final dbTasks = await _fetchTasks();

    for (Task task in tasks) {
      final index = dbTasks.indexWhere(
        (dbTask) => dbTask.id == task.id,
      );
      if (index == -1) {
        task = task.setPriority(dbTasks.length);
        dbTasks.add(task);
      } else {
        dbTasks[index] = task;
      }
    }

    dbTasks.sort((a, b) => a.priority.compareTo(b.priority));

    await _setTasks(dbTasks);
  }

  /// fetch tasks
  Future<List<Task>> fetchTasks() async {
    return await _fetchTasks();
  }

  /// remove task
  Future<void> removeTask(String taskId) async {
    final tasks = await _fetchTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await _setTasks(tasks);
  }
}

@Riverpod(keepAlive: true)
TasksService tasksService(TasksServiceRef ref) {
  return TasksService(
    authRepository: ref.watch(authRepositoryProvider),
    localTasksRepository: ref.watch(localTasksRepositoryProvider),
    remoteTasksRepository: ref.watch(remoteTasksRepositoryProvider),
  );
}

@riverpod
Future<Task?> taskFuture(TaskFutureRef ref, String taskId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return ref.watch(localTasksRepositoryProvider).fetchTask(taskId);
  }
  return ref.watch(remoteTasksRepositoryProvider).fetchTask(user.uid, taskId);
}

@riverpod
Stream<List<Task>> tasksStream(TasksStreamRef ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return ref.watch(localTasksRepositoryProvider).watchTasks();
  }
  return ref.watch(remoteTasksRepositoryProvider).watchTasks(user.uid);
}

@riverpod
Stream<Task?> taskStream(TaskStreamRef ref, String taskId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return ref.watch(localTasksRepositoryProvider).watchTask(taskId);
  }
  return ref.watch(remoteTasksRepositoryProvider).watchTask(user.uid, taskId);
}
