import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckListService {
  CheckListService({
    required this.authRepository,
    required this.localTaskInstancesRepository,
    required this.remoteTaskInstancesRepository,
  });

  final TestAuthRepository authRepository;
  final LocalTaskInstancesRepository localTaskInstancesRepository;
  final RemoteTaskInstancesRepository remoteTaskInstancesRepository;

  //Future<CheckList> _fetchCheckList
}

final checkListServiceProvider = Provider<CheckListService>(
  (ref) {
    return CheckListService(
      authRepository: ref.watch(
        authRepositoryProvider,
      ),
      localTaskInstancesRepository: ref.watch(
        localTaskInstancesRepositoryProvider,
      ),
      remoteTaskInstancesRepository: ref.watch(
        remoteTaskInstancesRepositoryProvider,
      ),
    );
  },
);
