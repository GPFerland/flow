import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(TaskInstances(taskInstancesList: []));
  });
  const testUser = AppUser(uid: 'abc', email: 'test@email.com');

  late MockAuthRepository authRepository;
  late MockLocalTaskInstancesRepository localTaskInstancesRepository;
  late MockRemoteTaskInstancesRepository remoteTaskInstancesRepository;
  setUp(() {
    authRepository = MockAuthRepository();
    localTaskInstancesRepository = MockLocalTaskInstancesRepository();
    remoteTaskInstancesRepository = MockRemoteTaskInstancesRepository();
  });

  TaskInstancesService makeTaskInstancesService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          authRepository,
        ),
        localTaskInstancesRepositoryProvider.overrideWithValue(
          localTaskInstancesRepository,
        ),
        remoteTaskInstancesRepositoryProvider.overrideWithValue(
          remoteTaskInstancesRepository,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container.read(taskInstancesServiceProvider);
  }

  group('TaskInstancesService', () {
    group('addTaskInstance', () {
      test('null user, task instance added to local repo', () async {
        // setup
        final testTaskInstance = createTestTaskInstance();
        final testTaskInstances = TaskInstances(
          taskInstancesList: [testTaskInstance],
        );
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(TaskInstances(taskInstancesList: [])),
        );
        when(
          () => localTaskInstancesRepository.setTaskInstances(
            testTaskInstances,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.addTaskInstance(testTaskInstance);
        // verify
        verify(
          () => localTaskInstancesRepository.fetchTaskInstances(),
        ).called(1);
        verifyNever(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            any(),
          ),
        );
        verify(
          () => localTaskInstancesRepository.setTaskInstances(
            testTaskInstances,
          ),
        ).called(1);
        verifyNever(
          () => remoteTaskInstancesRepository.setTaskInstances(
            any(),
            any(),
          ),
        );
      });
      test('non-null user, task instance added to remote repo', () async {
        // setup
        final testTaskInstance = createTestTaskInstance();
        final testTaskInstances = TaskInstances(
          taskInstancesList: [testTaskInstance],
        );
        when(() => authRepository.currentUser).thenReturn(testUser);
        when(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            testUser.uid,
          ),
        ).thenAnswer(
          (_) => Future.value(TaskInstances(taskInstancesList: [])),
        );
        when(
          () => remoteTaskInstancesRepository.setTaskInstances(
            testUser.uid,
            testTaskInstances,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.addTaskInstance(testTaskInstance);
        // verify
        verify(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            testUser.uid,
          ),
        ).called(1);
        verifyNever(
          () => localTaskInstancesRepository.fetchTaskInstances(),
        );
        verify(
          () => remoteTaskInstancesRepository.setTaskInstances(
            testUser.uid,
            testTaskInstances,
          ),
        ).called(1);
        verifyNever(
          () => localTaskInstancesRepository.setTaskInstances(
            any(),
          ),
        );
      });
    });
    group('setTaskInstance', () {
      test('null user, task instance set in local repo', () async {
        // setup
        final testTaskInstance = createTestTaskInstance();
        final testTaskInstances = TaskInstances(taskInstancesList: [
          testTaskInstance,
        ]);
        final updatedTestTaskInstance = testTaskInstance.copyWith(
          completed: true,
        );
        final updatedTestTaskInstances = TaskInstances(taskInstancesList: [
          updatedTestTaskInstance,
        ]);
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => localTaskInstancesRepository.setTaskInstances(
            updatedTestTaskInstances,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.setTaskInstance(updatedTestTaskInstance);
        // verify
        verify(
          () => localTaskInstancesRepository.fetchTaskInstances(),
        ).called(1);
        verifyNever(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            any(),
          ),
        );
        verify(
          () => localTaskInstancesRepository.setTaskInstances(
            updatedTestTaskInstances,
          ),
        ).called(1);
        verifyNever(
          () => remoteTaskInstancesRepository.setTaskInstances(
            any(),
            any(),
          ),
        );
      });
      test('non-null user, task instance set in remote repo', () async {
        // setup
        final testTaskInstance = createTestTaskInstance();
        final testTaskInstances = TaskInstances(taskInstancesList: [
          testTaskInstance,
        ]);
        final updatedTestTaskInstance = testTaskInstance.copyWith(
          completed: true,
        );
        final updatedTestTaskInstances = TaskInstances(taskInstancesList: [
          updatedTestTaskInstance,
        ]);
        when(() => authRepository.currentUser).thenReturn(testUser);
        when(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            testUser.uid,
          ),
        ).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => remoteTaskInstancesRepository.setTaskInstances(
            testUser.uid,
            updatedTestTaskInstances,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.setTaskInstance(updatedTestTaskInstance);
        // verify
        verify(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            testUser.uid,
          ),
        ).called(1);
        verifyNever(
          () => localTaskInstancesRepository.fetchTaskInstances(),
        );
        verify(
          () => remoteTaskInstancesRepository.setTaskInstances(
            testUser.uid,
            updatedTestTaskInstances,
          ),
        ).called(1);
        verifyNever(
          () => localTaskInstancesRepository.setTaskInstances(
            any(),
          ),
        );
      });
    });
    group('setTaskInstances', () {
      test('null user, task instances set in local repo', () async {
        // setup
        final testTaskInstances = TaskInstances(taskInstancesList: [
          createTestTaskInstance(id: '1'),
          createTestTaskInstance(id: '2'),
        ]);
        when(() => authRepository.currentUser).thenReturn(null);
        when(
          () => localTaskInstancesRepository.setTaskInstances(
            testTaskInstances,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.setTaskInstances(testTaskInstances);
        // verify
        verify(
          () => localTaskInstancesRepository.setTaskInstances(
            testTaskInstances,
          ),
        ).called(1);
        verifyNever(
          () => remoteTaskInstancesRepository.setTaskInstances(
            any(),
            any(),
          ),
        );
      });
      test('non-null user, task instances set to remote repo', () async {
        // setup
        final testTaskInstances = TaskInstances(taskInstancesList: [
          createTestTaskInstance(id: '1'),
          createTestTaskInstance(id: '2'),
        ]);
        when(() => authRepository.currentUser).thenReturn(testUser);
        when(
          () => remoteTaskInstancesRepository.setTaskInstances(
            testUser.uid,
            testTaskInstances,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.setTaskInstances(testTaskInstances);
        // verify
        verify(
          () => remoteTaskInstancesRepository.setTaskInstances(
            testUser.uid,
            testTaskInstances,
          ),
        ).called(1);
        verifyNever(
          () => localTaskInstancesRepository.setTaskInstances(
            testTaskInstances,
          ),
        );
      });
    });
    group('removeTaskInstance', () {
      test('null user, task instance removed from local repo', () async {
        // setup
        final testTaskInstance = createTestTaskInstance();
        final testTaskInstances = TaskInstances(taskInstancesList: [
          testTaskInstance,
        ]);
        final updatedTestTaskInstances = TaskInstances(taskInstancesList: []);
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => localTaskInstancesRepository.setTaskInstances(
            updatedTestTaskInstances,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.removeTaskInstance(testTaskInstance);
        // verify
        verify(
          () => localTaskInstancesRepository.fetchTaskInstances(),
        ).called(1);
        verifyNever(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            any(),
          ),
        );
        verify(
          () => localTaskInstancesRepository.setTaskInstances(
            updatedTestTaskInstances,
          ),
        ).called(1);
        verifyNever(
          () => remoteTaskInstancesRepository.setTaskInstances(
            any(),
            any(),
          ),
        );
      });
      test('non-null user, task instance removed from remote repo', () async {
        // setup
        final testTaskInstance = createTestTaskInstance();
        final testTaskInstances = TaskInstances(taskInstancesList: [
          testTaskInstance,
        ]);
        final updatedTestTaskInstances = TaskInstances(taskInstancesList: []);
        when(() => authRepository.currentUser).thenReturn(testUser);
        when(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            testUser.uid,
          ),
        ).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => remoteTaskInstancesRepository.setTaskInstances(
            testUser.uid,
            updatedTestTaskInstances,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.removeTaskInstance(testTaskInstance);
        // verify
        verify(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            testUser.uid,
          ),
        ).called(1);
        verifyNever(
          () => localTaskInstancesRepository.fetchTaskInstances(),
        );
        verify(
          () => remoteTaskInstancesRepository.setTaskInstances(
            testUser.uid,
            updatedTestTaskInstances,
          ),
        ).called(1);
        verifyNever(
          () => localTaskInstancesRepository.setTaskInstances(
            any(),
          ),
        );
      });
    });
    group('removeTaskInstances', () {
      test('null user, task instances removed from local repo', () async {
        // setup
        const testTaskId = 'removeId';
        final keepTaskInstance =
            createTestTaskInstance(id: '3').copyWith(taskId: 'keepId');
        final testTaskInstances = TaskInstances(taskInstancesList: [
          createTestTaskInstance(id: '1').copyWith(taskId: testTaskId),
          createTestTaskInstance(id: '2').copyWith(taskId: testTaskId),
          keepTaskInstance,
        ]);
        final updatedTestTaskInstances = TaskInstances(
          taskInstancesList: [keepTaskInstance],
        );
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => localTaskInstancesRepository.setTaskInstances(
            updatedTestTaskInstances,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.removeTasksInstances(testTaskId);
        // verify
        verify(
          () => localTaskInstancesRepository.fetchTaskInstances(),
        ).called(1);
        verifyNever(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            any(),
          ),
        );
        verify(
          () => localTaskInstancesRepository.setTaskInstances(
            updatedTestTaskInstances,
          ),
        ).called(1);
        verifyNever(
          () => remoteTaskInstancesRepository.setTaskInstances(
            any(),
            any(),
          ),
        );
      });
      test('non-null user, task instances removed from remote repo', () async {
        // setup
        const testTaskId = 'removeId';
        final keepTaskInstance =
            createTestTaskInstance(id: '3').copyWith(taskId: 'keepId');
        final testTaskInstances = TaskInstances(taskInstancesList: [
          createTestTaskInstance(id: '1').copyWith(taskId: testTaskId),
          createTestTaskInstance(id: '2').copyWith(taskId: testTaskId),
          keepTaskInstance,
        ]);
        final updatedTestTaskInstances = TaskInstances(
          taskInstancesList: [keepTaskInstance],
        );
        when(() => authRepository.currentUser).thenReturn(testUser);
        when(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            testUser.uid,
          ),
        ).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => remoteTaskInstancesRepository.setTaskInstances(
            testUser.uid,
            updatedTestTaskInstances,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.removeTasksInstances(testTaskId);
        // verify
        verify(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            testUser.uid,
          ),
        ).called(1);
        verifyNever(
          () => localTaskInstancesRepository.fetchTaskInstances(),
        );
        verify(
          () => remoteTaskInstancesRepository.setTaskInstances(
            testUser.uid,
            updatedTestTaskInstances,
          ),
        ).called(1);
        verifyNever(
          () => localTaskInstancesRepository.setTaskInstances(
            any(),
          ),
        );
      });
    });
    group('createTaskInstances', () {
      test('task NOT scheduled on date', () async {
        // setup
        final testDate = getDateNoTimeToday();
        final testTask = createTestTask().copyWith(
          frequencyType: FrequencyType.once,
          date: getDateNoTimeYesterday(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTaskInstance(testTask, testDate);
        // verify
        verifyNever(
          () => localTaskInstancesRepository.fetchTaskInstances(),
        );
        verifyNever(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            any(),
          ),
        );
        verifyNever(
          () => localTaskInstancesRepository.setTaskInstances(
            any(),
          ),
        );
        verifyNever(
          () => remoteTaskInstancesRepository.setTaskInstances(
            any(),
            any(),
          ),
        );
      });
      test('task instance already exists for date', () async {
        // setup
        final testDate = getDateNoTimeToday();
        final testTask = createTestTask().copyWith(
          frequencyType: FrequencyType.once,
          date: testDate,
        );
        final testTaskInstance = createTestTaskInstance().copyWith(
          taskId: testTask.id,
          initialDate: testDate,
        );
        final testTaskInstances = TaskInstances(
          taskInstancesList: [testTaskInstance],
        );
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTaskInstance(testTask, testDate);
        // verify
        verifyNever(
          () => remoteTaskInstancesRepository.fetchTaskInstances(
            any(),
          ),
        );
        verifyNever(
          () => localTaskInstancesRepository.setTaskInstances(
            any(),
          ),
        );
        verifyNever(
          () => remoteTaskInstancesRepository.setTaskInstances(
            any(),
            any(),
          ),
        );
      });
      test('once type task scheduled', () async {
        // setup
        final testDate = getDateNoTimeToday();
        final testTask = createTestTask().copyWith(
          frequencyType: FrequencyType.once,
          date: testDate,
        );
        final testTaskInstances = TaskInstances(taskInstancesList: []);
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTaskInstance(testTask, testDate);
        // verify
        verify(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).called(1);
      });
      test('daily type task scheduled', () async {
        // setup
        final testDate = getDateNoTimeToday();
        final testTask = createTestTask().copyWith(
          frequencyType: FrequencyType.daily,
        );
        final testTaskInstances = TaskInstances(taskInstancesList: []);
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTaskInstance(testTask, testDate);
        // verify
        verify(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).called(1);
      });
      test('weekly type task scheduled', () async {
        // setup
        final testDate = getDateNoTimeToday();
        final testTask = createTestTask().copyWith(
          frequencyType: FrequencyType.weekly,
          weekdays: [
            ...Weekday.values.where((weekday) {
              return weekday.weekdayIndex == testDate.weekday;
            }),
          ],
        );
        final testTaskInstances = TaskInstances(taskInstancesList: []);
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTaskInstance(testTask, testDate);
        // verify
        verify(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).called(1);
      });
      test('monthly type task scheduled, first day of the month', () async {
        // setup
        final testDate = getDateNoTimeToday().copyWith(day: 1);
        final testTask = createTestTask().copyWith(
          frequencyType: FrequencyType.monthly,
          monthdays: [
            const Monthday(
              weekday: Weekday.day,
              ordinal: Ordinal.first,
            )
          ],
        );
        final testTaskInstances = TaskInstances(taskInstancesList: []);
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTaskInstance(testTask, testDate);
        // verify
        verify(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).called(1);
      });
      test('monthly type task scheduled, last day of the month', () async {
        // setup
        final testDate = getDateNoTimeToday();
        final lastDayOfMonth = DateTime(testDate.year, testDate.month + 1, 0);
        final testTask = createTestTask().copyWith(
          frequencyType: FrequencyType.monthly,
          monthdays: [
            const Monthday(
              weekday: Weekday.day,
              ordinal: Ordinal.last,
            )
          ],
        );
        final testTaskInstances = TaskInstances(taskInstancesList: []);
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTaskInstance(testTask, lastDayOfMonth);
        // verify
        verify(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).called(1);
      });
      test('monthly type task scheduled, second tuesday', () async {
        // setup
        DateTime testDate = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          1,
        );
        while (testDate.weekday != Weekday.tue.weekdayIndex) {
          testDate = testDate.add(const Duration(days: 1));
        }
        testDate = testDate.add(const Duration(days: 7));
        final testTask = createTestTask().copyWith(
          frequencyType: FrequencyType.monthly,
          monthdays: [
            const Monthday(
              weekday: Weekday.tue,
              ordinal: Ordinal.second,
            )
          ],
        );
        final testTaskInstances = TaskInstances(taskInstancesList: []);
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTaskInstance(testTask, testDate);
        // verify
        verify(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).called(1);
      });
      test('monthly type task scheduled, last sunday', () async {
        // setup
        DateTime testDate = DateTime(
          DateTime.now().year,
          DateTime.now().month + 1,
          0,
        );
        while (testDate.weekday != Weekday.sun.weekdayIndex) {
          testDate = testDate.subtract(const Duration(days: 1));
        }
        final testTask = createTestTask().copyWith(
          frequencyType: FrequencyType.monthly,
          monthdays: [
            const Monthday(
              weekday: Weekday.sun,
              ordinal: Ordinal.last,
            )
          ],
        );
        final testTaskInstances = TaskInstances(taskInstancesList: []);
        when(() => authRepository.currentUser).thenReturn(null);
        when(localTaskInstancesRepository.fetchTaskInstances).thenAnswer(
          (_) => Future.value(testTaskInstances),
        );
        when(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTaskInstance(testTask, testDate);
        // verify
        verify(
          () => localTaskInstancesRepository.setTaskInstances(any()),
        ).called(1);
      });
    });
  });
}
