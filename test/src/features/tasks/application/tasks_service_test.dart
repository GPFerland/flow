import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

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

  group(
    'TasksService',
    () {
      group(
        'addTask',
        () {
          test(
            'null user, adds task to local tasks repo',
            () async {
              // setup
              final expectedTask = Task(
                id: '1',
                createdOn: DateTime.now(),
                title: 'Brush Teeth',
                icon: Icons.abc,
                color: Colors.blue,
                description: 'Brush Teeth in the Morning',
                showUntilCompleted: false,
              );
              final expectedTasks = Tasks(
                tasksList: [expectedTask],
              );
              when(() => authRepository.currentUser).thenReturn(null);
              when(localTasksRepository.fetchTasks).thenAnswer(
                (_) => Future.value(Tasks(tasksList: [])),
              );
              when(() => localTasksRepository.setTasks(expectedTasks))
                  .thenAnswer(
                (_) => Future.value(),
              );
              final tasksService = makeTasksService();
              // run
              await tasksService.addTask(expectedTask);
              // verify
              verify(
                () => localTasksRepository.setTasks(expectedTasks),
              ).called(1);
              verifyNever(
                () => remoteTasksRepository.setTasks(any(), any()),
              );
            },
          );
          test(
            'non-null user, adds task to remote tasks repo',
            () async {
              // setup
              const testUser = AppUser(uid: 'abc');
              final expectedTask = Task(
                id: '1',
                createdOn: DateTime.now(),
                title: 'Brush Teeth',
                icon: Icons.abc,
                color: Colors.blue,
                description: 'Brush Teeth in the Morning',
                showUntilCompleted: false,
              );
              final expectedTasks = Tasks(
                tasksList: [expectedTask],
              );
              when(() => authRepository.currentUser).thenReturn(testUser);
              when(() => remoteTasksRepository.fetchTasks(testUser.uid))
                  .thenAnswer(
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
            },
          );
        },
      );
      group(
        'removeTask',
        () {
          test(
            'null user, remove task from local tasks repo',
            () async {
              // setup
              final existingTask = Task(
                id: '1',
                createdOn: DateTime.now(),
                title: 'Brush Teeth',
                icon: Icons.abc,
                color: Colors.blue,
                description: 'Brush Teeth in the Morning',
                showUntilCompleted: false,
              );
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
              when(() => localTasksRepository.setTasks(expectedTasks))
                  .thenAnswer(
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
            },
          );
          test(
            'non-null user, adds task to remote tasks repo',
            () async {
              // setup
              const testUser = AppUser(uid: 'abc');
              final existingTask = Task(
                id: '1',
                createdOn: DateTime.now(),
                title: 'Brush Teeth',
                icon: Icons.abc,
                color: Colors.blue,
                description: 'Brush Teeth in the Morning',
                showUntilCompleted: false,
              );
              final existingTasks = Tasks(
                tasksList: [existingTask],
              );
              final expectedTasks = Tasks(
                tasksList: [],
              );
              when(() => authRepository.currentUser).thenReturn(testUser);
              when(() => remoteTasksRepository.fetchTasks(testUser.uid))
                  .thenAnswer(
                (_) => Future.value(
                  existingTasks,
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
            },
          );
        },
      );
    },
  );
}
