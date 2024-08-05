import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/src/features/authentication/data/auth_repository.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_service.g.dart';

class TasksService {
  TasksService({
    required this.authRepository,
    required this.localTasksRepository,
    required this.remoteTasksRepository,
  });

  final FirebaseAuth authRepository;
  final LocalTasksRepository localTasksRepository;
  final RemoteTasksRepository remoteTasksRepository;

  // * create
  Future<void> createTask(Task task) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await localTasksRepository.createTask(task);
    } else {
      await remoteTasksRepository.createTask(user.uid, task);
    }
  }

  // * read
  // all read functionality is handled by providers (defined below)

  // * update
  Future<void> updateTask(Task task) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await localTasksRepository.updateTask(task);
    } else {
      await remoteTasksRepository.updateTask(user.uid, task);
    }
  }

  Future<void> updateTasks(List<Task> tasks) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await localTasksRepository.updateTasks(tasks);
    } else {
      await remoteTasksRepository.updateTasks(user.uid, tasks);
    }
  }

  // * delete
  Future<void> deleteTask(String taskId) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await localTasksRepository.deleteTask(taskId);
    } else {
      await remoteTasksRepository.deleteTask(user.uid, taskId);
    }
  }

  Future<void> deleteTasks(List<String> taskIds) async {
    final user = authRepository.currentUser;
    if (user == null) {
      await localTasksRepository.deleteTasks(taskIds);
    } else {
      await remoteTasksRepository.deleteTasks(user.uid, taskIds);
    }
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
  } else {
    return ref.watch(remoteTasksRepositoryProvider).fetchTask(user.uid, taskId);
  }
}

@riverpod
Future<List<Task>> tasksFuture(TasksFutureRef ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return ref.watch(localTasksRepositoryProvider).fetchTasks();
  } else {
    return ref.watch(remoteTasksRepositoryProvider).fetchTasks(user.uid);
  }
}

@riverpod
Stream<Task?> taskStream(TaskStreamRef ref, String taskId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return ref.watch(localTasksRepositoryProvider).watchTask(taskId);
  } else {
    return ref.watch(remoteTasksRepositoryProvider).watchTask(user.uid, taskId);
  }
}

@riverpod
Stream<List<Task>> tasksStream(TasksStreamRef ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return ref.watch(localTasksRepositoryProvider).watchTasks();
  } else {
    return ref.watch(remoteTasksRepositoryProvider).watchTasks(user.uid);
  }
}
