import 'package:flow/src/exceptions/error_logger.dart';
import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksSyncService {
  TasksSyncService(this.ref) {
    _init();
  }

  final Ref ref;

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(
      authStateChangesProvider,
      (previous, next) {
        final previousUser = previous?.value;
        final user = next.value;
        if (previousUser == null && user != null) {
          _moveTasksToRemoteRepository(user.uid);
        }
      },
    );
  }

  Future<void> _moveTasksToRemoteRepository(String uid) async {
    try {
      // Get the local tasks
      final localTasksRepository = ref.read(localTasksRepositoryProvider);
      final localTasks = await localTasksRepository.fetchTasks();
      if (localTasks.isNotEmpty) {
        // Get the remote tasks data
        final remoteTasksRepository = ref.read(remoteTasksRepositoryProvider);
        final remoteTasks = await remoteTasksRepository.fetchTasks(uid);
        // Add all of the local tasks to the remote tasks
        remoteTasks.addAll(localTasks);
        // Write the updated remote tasks data to the repository
        await remoteTasksRepository.setTasks(uid, remoteTasks);
        // Remove all tasks from the local tasks repository
        await localTasksRepository.setTasks([]);
      }
    } catch (exception, stackTrace) {
      ref.read(errorLoggerProvider).logError(exception, stackTrace);
    }
  }
}

final tasksSyncServiceProvider = Provider<TasksSyncService>(
  (ref) {
    return TasksSyncService(ref);
  },
);
