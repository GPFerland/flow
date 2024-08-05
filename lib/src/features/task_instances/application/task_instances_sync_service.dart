import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/src/exceptions/error_logger.dart';
import 'package:flow/src/features/authentication/data/auth_repository.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_instances_sync_service.g.dart';

class TaskInstancesSyncService {
  TaskInstancesSyncService(this.ref) {
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
          // move the local task instances to the remote repository
          _moveTaskInstancesToRemoteRepository(user.uid);
        }
      },
    );
  }

  Future<void> _moveTaskInstancesToRemoteRepository(String uid) async {
    try {
      // get the local task instances data
      final localTaskInstancesRepository = ref.read(
        localTaskInstancesRepositoryProvider,
      );
      final localTaskInstances =
          await localTaskInstancesRepository.fetchTaskInstances();
      if (localTaskInstances.isNotEmpty) {
        final remoteTaskInstancesRepository = ref.read(
          remoteTaskInstancesRepositoryProvider,
        );
        // add the local tasks to the remote repository
        await remoteTaskInstancesRepository.createTaskInstances(
          uid,
          localTaskInstances,
        );
        // delete all tasks from the local tasks repository
        await localTaskInstancesRepository.deleteTaskInstances(
          localTaskInstances.map((taskInstance) => taskInstance.id).toList(),
        );
      }
    } catch (exception, stackTrace) {
      //todo - update to custom exception
      ref.read(errorLoggerProvider).logError(exception, stackTrace);
    }
  }
}

@Riverpod(keepAlive: true)
TaskInstancesSyncService taskInstancesSyncService(
  TaskInstancesSyncServiceRef ref,
) {
  return TaskInstancesSyncService(ref);
}
