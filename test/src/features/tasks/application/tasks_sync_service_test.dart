import 'package:flow/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flow/src/features/tasks/application/tasks_sync_service.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockLocalTasksRepository localTasksRepository;
  late MockRemoteTasksRepository remoteTasksRepository;

  setUp(
    () {
      authRepository = MockAuthRepository();
      localTasksRepository = MockLocalTasksRepository();
      remoteTasksRepository = MockRemoteTasksRepository();
    },
  );

  TasksSyncService makeTasksSyncService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      localTasksRepositoryProvider.overrideWithValue(localTasksRepository),
      remoteTasksRepositoryProvider.overrideWithValue(remoteTasksRepository),
    ]);
    addTearDown(container.dispose);
    return container.read(tasksSyncServiceProvider);
  }

  group(
    'TasksSyncService',
    () {
      Future<void> runTasksSyncTest({
        required List<Task> localTasks,
        required List<Task> remoteTasks,
        required List<Task> expectedRemoteTasks,
      }) async {
        const uid = '123';
        when(authRepository.authStateChanges).thenAnswer(
          (_) => Stream.value(const AppUser(uid: uid, email: 'test@test.com')),
        );
        when(localTasksRepository.fetchTasks).thenAnswer(
          (_) => Future.value(localTasks),
        );
        when(() => remoteTasksRepository.fetchTasks(uid)).thenAnswer(
          (_) => Future.value(remoteTasks),
        );
        when(() => remoteTasksRepository.updateTasks(uid, expectedRemoteTasks))
            .thenAnswer(
          (_) => Future.value(),
        );
        when(() => localTasksRepository.updateTasks([])).thenAnswer(
          (_) => Future.value(),
        );
        // create tasks sync service to trigger sync (no return required)
        makeTasksSyncService();
        // wait for all the stubbed methods to return a value
        await Future.delayed(const Duration());
        //verify
        if (localTasks.isNotEmpty) {
          verify(
            () => remoteTasksRepository.updateTasks(uid, expectedRemoteTasks),
          ).called(1);
          verify(
            () => localTasksRepository.updateTasks([]),
          ).called(1);
        } else {
          verifyNever(
            () => remoteTasksRepository.updateTasks(uid, expectedRemoteTasks),
          );
          verifyNever(
            () => localTasksRepository.updateTasks([]),
          );
        }
      }

      test(
        'no local or remote tasks, remote stays empty',
        () async {
          await runTasksSyncTest(
            localTasks: [],
            remoteTasks: [],
            expectedRemoteTasks: [],
          );
        },
      );

      test(
        'no local tasks but remote tasks, remote tasks unchanged',
        () async {
          await runTasksSyncTest(
            localTasks: [],
            remoteTasks: [createTestTask()],
            expectedRemoteTasks: [createTestTask()],
          );
        },
      );

      test(
        'local tasks but no remote tasks, local tasks moved to remote',
        () async {
          await runTasksSyncTest(
            localTasks: [createTestTask()],
            remoteTasks: [],
            expectedRemoteTasks: [createTestTask()],
          );
        },
      );

      test(
        'local tasks and remote tasks, local added to remote',
        () async {
          await runTasksSyncTest(
            localTasks: [createTestTask(id: '1')],
            remoteTasks: [createTestTask(id: '2')],
            expectedRemoteTasks: [
              createTestTask(id: '2'),
              createTestTask(id: '1'),
            ],
          );
        },
      );
    },
  );
}
