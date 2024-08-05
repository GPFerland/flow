import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/src/exceptions/error_logger.dart';
import 'package:flow/src/features/authentication/data/auth_repository.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tasks_sync_service.g.dart';

class TasksSyncService {
  TasksSyncService(this.ref) {
    _init();
  }

  final Ref ref;

  void _init() {
    // listen for changes of the auth state, i.e. user signs in or out
    ref.listen<AsyncValue<User?>>(
      authStateChangesProvider,
      (previous, next) {
        final previousUser = previous?.value;
        final user = next.value;
        // if the user is signing in
        if (previousUser == null && user != null) {
          // move the local tasks to the remote repository
          _moveTasksToRemoteRepository(user.uid);
        }
      },
    );
  }

  Future<void> _moveTasksToRemoteRepository(String uid) async {
    try {
      // get the local tasks data
      final localTasksRepository = ref.read(
        localTasksRepositoryProvider,
      );
      final localTasks = await localTasksRepository.fetchTasks();
      if (localTasks.isNotEmpty) {
        final remoteTasksRepository = ref.read(
          remoteTasksRepositoryProvider,
        );
        // add the local tasks to the remote repository
        await remoteTasksRepository.createTasks(
          uid,
          localTasks,
        );
        // delete all tasks from the local tasks repository
        await localTasksRepository.deleteTasks(
          localTasks.map((task) => task.id).toList(),
        );
      }
    } catch (exception, stackTrace) {
      //todo - update to custom exception
      ref.read(errorLoggerProvider).logError(exception, stackTrace);
    }
  }
}

@Riverpod(keepAlive: true)
TasksSyncService tasksSyncService(TasksSyncServiceRef ref) {
  return TasksSyncService(ref);
}
