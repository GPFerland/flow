import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flow/src/features/task_instances/application/task_instances_sync_service.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockLocalTaskInstancesRepository localTaskInstancesRepository;
  late MockRemoteTaskInstancesRepository remoteTaskInstancesRepository;

  setUp(
    () {
      authRepository = MockAuthRepository();
      localTaskInstancesRepository = MockLocalTaskInstancesRepository();
      remoteTaskInstancesRepository = MockRemoteTaskInstancesRepository();
    },
  );

  TaskInstancesSyncService makeTaskInstancesSyncService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      localTaskInstancesRepositoryProvider.overrideWithValue(
        localTaskInstancesRepository,
      ),
      remoteTaskInstancesRepositoryProvider.overrideWithValue(
        remoteTaskInstancesRepository,
      ),
    ]);
    addTearDown(container.dispose);
    return container.read(taskInstancesSyncServiceProvider);
  }

  group('TaskInstancesSyncService', () {
    Future<void> runTaskInstancesSyncTest({
      required TaskInstances localTaskInstances,
      required TaskInstances remoteTaskInstances,
      required TaskInstances expectedRemoteTaskInstances,
    }) async {
      // setup
      const uid = '123';
      when(authRepository.authStateChanges).thenAnswer(
        (_) => Stream.value(const AppUser(uid: uid, email: 'test@test.com')),
      );
      when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
        (_) => Future.value(localTaskInstances),
      );
      when(
        () => remoteTaskInstancesRepository.fetchTaskInstances(uid),
      ).thenAnswer(
        (_) => Future.value(remoteTaskInstances),
      );
      when(
        () => remoteTaskInstancesRepository.setTaskInstances(
          uid,
          expectedRemoteTaskInstances,
        ),
      ).thenAnswer(
        (_) => Future.value(),
      );
      when(
        () => localTaskInstancesRepository.setTaskInstances(
          TaskInstances(taskInstancesList: []),
        ),
      ).thenAnswer(
        (_) => Future.value(),
      );
      // run - create task instances sync service to trigger sync
      makeTaskInstancesSyncService();
      // wait for all the stubbed methods to return a value
      await Future.delayed(const Duration());
      //verify
      if (localTaskInstances.taskInstancesList.isNotEmpty) {
        verify(
          () => remoteTaskInstancesRepository.setTaskInstances(
            uid,
            expectedRemoteTaskInstances,
          ),
        ).called(1);
        verify(
          () => localTaskInstancesRepository.setTaskInstances(
            TaskInstances(taskInstancesList: []),
          ),
        ).called(1);
      } else {
        verifyNever(
          () => remoteTaskInstancesRepository.setTaskInstances(
            uid,
            expectedRemoteTaskInstances,
          ),
        );
        verifyNever(
          () => localTaskInstancesRepository.setTaskInstances(
            TaskInstances(taskInstancesList: []),
          ),
        );
      }
    }

    test('local and remote empty, remote stays empty', () async {
      await runTaskInstancesSyncTest(
        localTaskInstances: TaskInstances(taskInstancesList: []),
        remoteTaskInstances: TaskInstances(taskInstancesList: []),
        expectedRemoteTaskInstances: TaskInstances(taskInstancesList: []),
      );
    });

    test('local empty, remote populated, remote is unchanged', () async {
      await runTaskInstancesSyncTest(
        localTaskInstances: TaskInstances(taskInstancesList: []),
        remoteTaskInstances: TaskInstances(
          taskInstancesList: [createTestTaskInstance()],
        ),
        expectedRemoteTaskInstances: TaskInstances(
          taskInstancesList: [createTestTaskInstance()],
        ),
      );
    });

    test('local populated, remote empty, local added to remote', () async {
      await runTaskInstancesSyncTest(
        localTaskInstances: TaskInstances(
          taskInstancesList: [createTestTaskInstance()],
        ),
        remoteTaskInstances: TaskInstances(
          taskInstancesList: [],
        ),
        expectedRemoteTaskInstances: TaskInstances(
          taskInstancesList: [createTestTaskInstance()],
        ),
      );
    });

    test('local and remote populated, local added to remote', () async {
      await runTaskInstancesSyncTest(
        localTaskInstances: TaskInstances(
          taskInstancesList: [createTestTaskInstance(id: '1')],
        ),
        remoteTaskInstances: TaskInstances(
          taskInstancesList: [createTestTaskInstance(id: '2')],
        ),
        expectedRemoteTaskInstances: TaskInstances(taskInstancesList: [
          createTestTaskInstance(id: '2'),
          createTestTaskInstance(id: '1'),
        ]),
      );
    });
  });
}