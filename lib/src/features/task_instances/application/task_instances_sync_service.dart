import 'package:flow/src/exceptions/error_logger.dart';
import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/authentication/domain/app_user.dart';
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
    ref.listen<AsyncValue<AppUser?>>(
      authStateChangesProvider,
      (previous, next) {
        final previousUser = previous?.value;
        final user = next.value;
        if (previousUser == null && user != null) {
          _moveTaskInstancesToRemoteRepository(user.uid);
        }
      },
    );
  }

  Future<void> _moveTaskInstancesToRemoteRepository(String uid) async {
    try {
      // Get the local task instances data
      final localTaskInstancesRepository = ref.read(
        localTaskInstancesRepositoryProvider,
      );
      final localTaskInstances =
          await localTaskInstancesRepository.fetchTaskInstances();
      if (localTaskInstances.isNotEmpty) {
        // Get the remote task instances data
        final remoteTaskInstancesRepository = ref.read(
          remoteTaskInstancesRepositoryProvider,
        );
        final remoteTaskInstances =
            await remoteTaskInstancesRepository.fetchTaskInstances(uid);
        // Add all of the local task instances to the remote task instances
        remoteTaskInstances.addAll(localTaskInstances);
        // Write the updated remote task instances data to the repository
        await remoteTaskInstancesRepository.setTaskInstances(
          uid,
          remoteTaskInstances,
        );
        // Remove all task instances from the local task instances repository
        await localTaskInstancesRepository.setTaskInstances([]);
      }
    } catch (exception, stackTrace) {
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
