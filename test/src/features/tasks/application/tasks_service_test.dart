import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

void main() {
  const testUser = AppUser(uid: 'abc', email: 'test@email.com');

  // mock repositories the tasks service depends on
  late MockAuthRepository authRepository;
  late MockLocalTasksRepository localTasksRepository;
  late MockRemoteTasksRepository remoteTasksRepository;

  setUp(() {
    // set fallback for ???
    registerFallbackValue([]);
    // initialize mock repositories
    authRepository = MockAuthRepository();
    localTasksRepository = MockLocalTasksRepository();
    remoteTasksRepository = MockRemoteTasksRepository();
  });

  TasksService makeTasksService() {
    // build container with mock repositories
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(
        authRepository,
      ),
      localTasksRepositoryProvider.overrideWithValue(
        localTasksRepository,
      ),
      remoteTasksRepositoryProvider.overrideWithValue(
        remoteTasksRepository,
      ),
    ]);
    addTearDown(container.dispose);
    // read the provider to create the tasks service
    return container.read(tasksServiceProvider);
  }

  // mock required repository function calls
  void setUpRepositories({
    required AppUser? currentUserReturn,
    required List<Task> fetchTasksReturn,
    required List<Task>? setTasksArg,
  }) {
    when(
      () => authRepository.currentUser,
    ).thenAnswer(
      (_) => currentUserReturn,
    );
    if (currentUserReturn == null) {
      // mock the local repositories
      when(
        () => localTasksRepository.fetchTasks(),
      ).thenAnswer(
        (_) => Future.value(fetchTasksReturn),
      );
      when(
        () => localTasksRepository.setTasks(
          setTasksArg ?? any(),
        ),
      ).thenAnswer(
        (_) => Future.value(),
      );
    } else {
      // mock the remote repositories
      when(
        () => remoteTasksRepository.fetchTasks(testUser.uid),
      ).thenAnswer(
        (_) => Future.value(fetchTasksReturn),
      );
      when(
        () => remoteTasksRepository.setTasks(
          testUser.uid,
          setTasksArg ?? any(),
        ),
      ).thenAnswer(
        (_) => Future.value(),
      );
    }
  }

  // verify expected repository function calls
  void verifyRepositories({
    required AppUser? user,
    required List<Task>? setTasksArg,
  }) {
    if (user == null) {
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
          setTasksArg ?? any(),
        ),
      ).called(1);
      verifyNever(
        () => remoteTasksRepository.setTasks(
          any(),
          any(),
        ),
      );
    } else {
      verify(
        () => remoteTasksRepository.fetchTasks(
          testUser.uid,
        ),
      ).called(1);
      verifyNever(
        () => localTasksRepository.fetchTasks(),
      );
      verify(
        () => remoteTasksRepository.setTasks(
          testUser.uid,
          setTasksArg ?? any(),
        ),
      ).called(1);
      verifyNever(
        () => localTasksRepository.setTasks(
          any(),
        ),
      );
    }
  }

  group('TasksService', () {
    group('setTasks', () {
      test('null user, new task set in local repo', () async {
        // setup
        final testTask = createTestTask();
        final testTasks = [testTask];
        setUpRepositories(
          currentUserReturn: null,
          fetchTasksReturn: [],
          setTasksArg: testTasks,
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.setTasks(testTasks);
        // verify
        verifyRepositories(
          user: null,
          setTasksArg: testTasks,
        );
      });
      test('non-null user, new task set in remote repo', () async {
        // setup
        final testTask = createTestTask();
        final testTasks = [testTask];
        setUpRepositories(
          currentUserReturn: testUser,
          fetchTasksReturn: [],
          setTasksArg: testTasks,
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.setTasks(testTasks);
        // verify
        verifyRepositories(
          user: testUser,
          setTasksArg: testTasks,
        );
      });
      test('null user, existing task set in local repo', () async {
        // setup
        final testTask = createTestTask();
        final testTasks = [testTask];
        final updatedTestTask = testTask.copyWith(title: 'New Title');
        final updatedTestTasks = [updatedTestTask];
        setUpRepositories(
          currentUserReturn: null,
          fetchTasksReturn: testTasks,
          setTasksArg: updatedTestTasks,
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.setTasks([updatedTestTask]);
        // verify
        verifyRepositories(
          user: null,
          setTasksArg: updatedTestTasks,
        );
      });
      test('non-null user, existing task set in remote repo', () async {
        // setup
        final testTask = createTestTask();
        final testTasks = [testTask];
        final updatedTestTask = testTask.copyWith(title: 'New Title');
        final updatedTestTasks = [updatedTestTask];
        setUpRepositories(
          currentUserReturn: testUser,
          fetchTasksReturn: testTasks,
          setTasksArg: updatedTestTasks,
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.setTasks([updatedTestTask]);
        // verify
        verifyRepositories(
          user: testUser,
          setTasksArg: testTasks,
        );
      });
    });

    group('fetchTasks', () {
      test('null user, fetch tasks from local repo', () async {
        // setup
        final testTask = createTestTask();
        final testTasks = [testTask];
        setUpRepositories(
          currentUserReturn: null,
          fetchTasksReturn: testTasks,
          setTasksArg: null,
        );
        final tasksService = makeTasksService();
        // run
        final fetchedTasks = await tasksService.fetchTasks();
        // verify
        verify(() => localTasksRepository.fetchTasks()).called(1);
        expect(fetchedTasks, testTasks);
      });
      test('non-null user, fetch tasks from remote tasks repo', () async {
        // setup
        final testTask = createTestTask();
        final testTasks = [testTask];
        setUpRepositories(
          currentUserReturn: testUser,
          fetchTasksReturn: testTasks,
          setTasksArg: null,
        );
        final tasksService = makeTasksService();
        // run
        final fetchedTasks = await tasksService.fetchTasks();
        // verify
        verify(() => remoteTasksRepository.fetchTasks(testUser.uid)).called(1);
        expect(fetchedTasks, testTasks);
      });
    });

    group('removeTask', () {
      test('null user, remove task from local tasks repo', () async {
        // setup
        final testTask = createTestTask();
        final testTasks = [testTask];
        final expectedTasks = <Task>[];
        setUpRepositories(
          currentUserReturn: null,
          fetchTasksReturn: testTasks,
          setTasksArg: expectedTasks,
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.removeTask(testTask.id);
        // verify
        verifyRepositories(
          user: null,
          setTasksArg: expectedTasks,
        );
      });
    });
  });
}
