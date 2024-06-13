import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/mutable_task.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
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

  /// fetch the tasks from the local or remote repository
  /// depending on the user auth state
  Future<Tasks> _fetchTasks() {
    final user = authRepository.currentUser;
    if (user != null) {
      return remoteTasksRepository.fetchTasks(user.uid);
    } else {
      return localTasksRepository.fetchTasks();
    }
  }

  /// save the tasks to the local or remote repository
  /// depending on the user auth state
  Future<void> _setTasks(Tasks tasks) async {
    final user = authRepository.currentUser;
    if (user != null) {
      await remoteTasksRepository.setTasks(user.uid, tasks);
    } else {
      await localTasksRepository.setTasks(tasks);
    }
  }

  /// adds a task in the local or remote task depending on the user auth state
  Future<void> addTask(Task task) async {
    final tasks = await _fetchTasks();
    final updated = tasks.addTask(task);
    await _setTasks(updated);
  }

  /// removes a task from the local or remote task depending on the user auth
  /// state
  Future<void> removeTask(Task task) async {
    final tasks = await _fetchTasks();
    final updated = tasks.removeTask(task);
    await _setTasks(updated);
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
