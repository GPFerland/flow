import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockLocalTasksRepository localTasksRepository;
  late MockRemoteTasksRepository remoteTasksRepository;

  setUpAll(() {
    registerFallbackValue(Tasks(tasksList: []));
  });

  setUp(
    () {
      authRepository = MockAuthRepository();
      localTasksRepository = MockLocalTasksRepository();
      remoteTasksRepository = MockRemoteTasksRepository();
    },
  );

  TasksService makeTasksService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        localTasksRepositoryProvider.overrideWithValue(localTasksRepository),
        remoteTasksRepositoryProvider.overrideWithValue(remoteTasksRepository),
      ],
    );
    addTearDown(container.dispose);
    return container.read(tasksServiceProvider);
  }

  group('TasksService', () {
    group('fetchTasks', () {
      test('null user, fetch tasks from local repo', () async {
        // setup
        final expectedTask = createTestTask();
        final expectedTasks = Tasks(
          tasksList: [expectedTask],
        );
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTasksRepository.fetchTasks).thenAnswer(
          (_) => Future.value(expectedTasks),
        );
        final tasksService = makeTasksService();
        // run
        final fetchedTasks = await tasksService.fetchTasks();
        // verify
        verify(
          () => localTasksRepository.fetchTasks(),
        ).called(1);
        verifyNever(
          () => remoteTasksRepository.fetchTasks(
            any(),
          ),
        );
        expect(fetchedTasks, expectedTasks);
      });
      test('non-null user, fetch tasks from remote tasks repo', () async {
        // setup
        const testUser = AppUser(uid: 'abc');
        final expectedTask = createTestTask();
        final expectedTasks = Tasks(
          tasksList: [expectedTask],
        );
        when(() => authRepository.currentUser).thenReturn(testUser);
        when(
          () => remoteTasksRepository.fetchTasks(testUser.uid),
        ).thenAnswer(
          (_) => Future.value(expectedTasks),
        );
        final tasksService = makeTasksService();
        // run
        final fetchedTasks = await tasksService.fetchTasks();
        // verify
        verify(
          () => remoteTasksRepository.fetchTasks(testUser.uid),
        ).called(1);
        verifyNever(
          () => localTasksRepository.fetchTasks(),
        );
        expect(fetchedTasks, expectedTasks);
      });
    });
    group('addTask', () {
      test('null user, task added to local repo', () async {
        // setup
        final expectedTask = createTestTask();
        final expectedTasks = Tasks(
          tasksList: [expectedTask],
        );
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTasksRepository.fetchTasks).thenAnswer(
          (_) => Future.value(Tasks(tasksList: [])),
        );
        when(
          () => localTasksRepository.setTasks(expectedTasks),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.addTask(expectedTask);
        // verify
        verify(
          () => localTasksRepository.fetchTasks(),
        ).called(1);
        verifyNever(
          () => remoteTasksRepository.fetchTasks(
            any(),
          ),
        );
        verify(
          () => localTasksRepository.setTasks(
            expectedTasks,
          ),
        ).called(1);
        verifyNever(
          () => remoteTasksRepository.setTasks(
            any(),
            any(),
          ),
        );
      });
      test('non-null user, adds task to remote tasks repo', () async {
        // setup
        const testUser = AppUser(uid: 'abc');
        final expectedTask = createTestTask();
        final expectedTasks = Tasks(
          tasksList: [expectedTask],
        );
        when(() => authRepository.currentUser).thenReturn(testUser);
        when(() => remoteTasksRepository.fetchTasks(testUser.uid)).thenAnswer(
          (_) => Future.value(
            Tasks(tasksList: []),
          ),
        );
        when(
          () => remoteTasksRepository.setTasks(
            testUser.uid,
            expectedTasks,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.addTask(expectedTask);
        // verify
        verify(
          () => remoteTasksRepository.setTasks(
            testUser.uid,
            expectedTasks,
          ),
        ).called(1);
        verifyNever(
          () => localTasksRepository.setTasks(any()),
        );
      });
    });
    group('setTask', () {
      test('null user, sets task to local tasks repo', () async {
        // setup
        final expectedTask = createTestTask();
        final expectedTasks = Tasks(
          tasksList: [expectedTask],
        );
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTasksRepository.fetchTasks).thenAnswer(
          (_) => Future.value(Tasks(tasksList: [])),
        );
        when(() => localTasksRepository.setTasks(expectedTasks)).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.setTask(expectedTask);
        // verify
        verify(
          () => localTasksRepository.setTasks(expectedTasks),
        ).called(1);
        verifyNever(
          () => remoteTasksRepository.setTasks(any(), any()),
        );
      });
      test('non-null user, adds task to remote tasks repo', () async {
        // setup
        const testUser = AppUser(uid: 'abc');
        final expectedTask = createTestTask();
        final expectedTasks = Tasks(
          tasksList: [expectedTask],
        );
        when(() => authRepository.currentUser).thenReturn(testUser);
        when(() => remoteTasksRepository.fetchTasks(testUser.uid)).thenAnswer(
          (_) => Future.value(
            Tasks(tasksList: []),
          ),
        );
        when(
          () => remoteTasksRepository.setTasks(
            testUser.uid,
            expectedTasks,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.setTask(expectedTask);
        // verify
        verify(
          () => remoteTasksRepository.setTasks(
            testUser.uid,
            expectedTasks,
          ),
        ).called(1);
        verifyNever(
          () => localTasksRepository.setTasks(any()),
        );
      });
    });
    group('removeTask', () {
      test('null user, remove task from local tasks repo', () async {
        // setup
        final existingTask = createTestTask();
        final existingTasks = Tasks(
          tasksList: [existingTask],
        );
        final expectedTasks = Tasks(
          tasksList: [],
        );
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTasksRepository.fetchTasks).thenAnswer(
          (_) => Future.value(existingTasks),
        );
        when(() => localTasksRepository.setTasks(expectedTasks)).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.removeTask(existingTask);
        // verify
        verify(
          () => localTasksRepository.setTasks(expectedTasks),
        ).called(1);
        verifyNever(
          () => remoteTasksRepository.setTasks(any(), any()),
        );
      });
      test('non-null user, adds task to remote tasks repo', () async {
        // setup
        const testUser = AppUser(uid: 'abc');
        final existingTask = createTestTask();
        final existingTasks = Tasks(
          tasksList: [existingTask],
        );
        final expectedTasks = Tasks(
          tasksList: [],
        );
        when(() => authRepository.currentUser).thenReturn(testUser);
        when(
          () => remoteTasksRepository.fetchTasks(testUser.uid),
        ).thenAnswer(
          (_) => Future.value(existingTasks),
        );
        when(
          () => remoteTasksRepository.setTasks(
            testUser.uid,
            expectedTasks,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.removeTask(existingTask);
        // verify
        verify(
          () => remoteTasksRepository.setTasks(
            testUser.uid,
            expectedTasks,
          ),
        ).called(1);
        verifyNever(
          () => localTasksRepository.setTasks(any()),
        );
      });
    });
  });
}
