import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/remote_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RemoteTaskInstancesRepository {
  Future<void> setTaskInstances(String uid, List<TaskInstance> taskInstances);

  Future<List<TaskInstance>> fetchTaskInstances(String uid);

  Future<TaskInstance?> fetchTaskInstance(String uid, String taskInstanceId);

  Stream<List<TaskInstance>> watchTaskInstances(String uid);

  Stream<TaskInstance?> watchTaskInstance(String uid, String taskInstanceId);
}

final remoteTaskInstancesRepositoryProvider =
    Provider<RemoteTaskInstancesRepository>(
  (ref) {
    // * Override in main()
    throw UnimplementedError();
  },
);

final remoteTaskInstancesFutureProvider =
    FutureProvider.autoDispose.family<List<TaskInstance>, String>(
  (ref, uid) {
    final taskInstancesRepository = ref.watch(
      remoteTaskInstancesRepositoryProvider,
    );
    return taskInstancesRepository.fetchTaskInstances(uid);
  },
);

final remoteTaskInstanceFutureProvider =
    FutureProvider.autoDispose.family<TaskInstance?, RemoteItem>(
  (ref, remoteItem) {
    final taskInstancesRepository = ref.watch(
      remoteTaskInstancesRepositoryProvider,
    );
    return taskInstancesRepository.fetchTaskInstance(
      remoteItem.uid,
      remoteItem.itemId,
    );
  },
);

final remoteTaskInstancesStreamProvider =
    StreamProvider.autoDispose.family<List<TaskInstance>, String>(
  (ref, uid) {
    final taskInstancesRepository = ref.watch(
      remoteTaskInstancesRepositoryProvider,
    );
    return taskInstancesRepository.watchTaskInstances(uid);
  },
);

final remoteTaskInstanceStreamProvider =
    StreamProvider.autoDispose.family<TaskInstance?, RemoteItem>(
  (ref, remoteItem) {
    final taskInstancesRepository = ref.watch(
      remoteTaskInstancesRepositoryProvider,
    );
    return taskInstancesRepository.watchTaskInstance(
      remoteItem.uid,
      remoteItem.itemId,
    );
  },
);
