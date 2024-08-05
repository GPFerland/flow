import 'package:flow/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../../utils.dart';

void main() {
  const testUser = AppUser(uid: 'abc', email: 'test@email.com');

  // mock repositories the task instances service depends on
  late MockAuthRepository authRepository;
  late MockDateRepository dateRepository;
  late MockLocalTaskInstancesRepository localTaskInstancesRepository;
  late MockRemoteTaskInstancesRepository remoteTaskInstancesRepository;

  setUp(() {
    // set fallback for ???
    registerFallbackValue([]);
    // initialize mock repositories
    authRepository = MockAuthRepository();
    dateRepository = MockDateRepository();
    localTaskInstancesRepository = MockLocalTaskInstancesRepository();
    remoteTaskInstancesRepository = MockRemoteTaskInstancesRepository();
  });

  TaskInstancesService makeTaskInstancesService() {
    // build container with mock repositories
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(
        authRepository,
      ),
      dateRepositoryProvider.overrideWithValue(
        dateRepository,
      ),
      localTaskInstancesRepositoryProvider.overrideWithValue(
        localTaskInstancesRepository,
      ),
      remoteTaskInstancesRepositoryProvider.overrideWithValue(
        remoteTaskInstancesRepository,
      ),
    ]);
    addTearDown(container.dispose);
    // read the provider to create the task instances service
    return container.read(taskInstancesServiceProvider);
  }

  // mock required repository function calls
  void setUpRepositories({
    required AppUser? currentUserReturn,
    required List<TaskInstance> fetchTaskInstancesReturn,
    required List<TaskInstance>? updateTaskInstancesArg,
  }) {
    when(
      () => authRepository.currentUser,
    ).thenAnswer(
      (_) => currentUserReturn,
    );
    when(
      () => dateRepository.date,
    ).thenAnswer(
      (_) => getDateNoTimeToday(),
    );
    when(
      () => dateRepository.dateBefore,
    ).thenAnswer(
      (_) => getDateNoTimeYesterday(),
    );
    when(
      () => dateRepository.dateAfter,
    ).thenAnswer(
      (_) => getDateNoTimeTomorrow(),
    );
    if (currentUserReturn == null) {
      // mock the local repositories
      when(
        () => localTaskInstancesRepository.fetchTaskInstances(),
      ).thenAnswer(
        (_) => Future.value(fetchTaskInstancesReturn),
      );
      when(
        () => localTaskInstancesRepository.updateTaskInstances(
          updateTaskInstancesArg ?? any(),
        ),
      ).thenAnswer(
        (_) => Future.value(),
      );
    } else {
      // mock the remote repositories
      when(
        () => remoteTaskInstancesRepository.fetchTaskInstances(testUser.uid),
      ).thenAnswer(
        (_) => Future.value(fetchTaskInstancesReturn),
      );
      when(
        () => remoteTaskInstancesRepository.updateTaskInstances(
          testUser.uid,
          updateTaskInstancesArg ?? any(),
        ),
      ).thenAnswer(
        (_) => Future.value(),
      );
    }
  }

  // verify expected repository function calls
  void verifyRepositories({
    required AppUser? user,
    required List<TaskInstance>? updateTaskInstancesArg,
  }) {
    if (user == null) {
      verify(
        () => localTaskInstancesRepository.fetchTaskInstances(),
      ).called(1);
      verifyNever(
        () => remoteTaskInstancesRepository.fetchTaskInstances(
          any(),
        ),
      );
      verify(
        () => localTaskInstancesRepository.updateTaskInstances(
          updateTaskInstancesArg ?? any(),
        ),
      ).called(1);
      verifyNever(
        () => remoteTaskInstancesRepository.updateTaskInstances(
          any(),
          any(),
        ),
      );
    } else {
      verify(
        () => remoteTaskInstancesRepository.fetchTaskInstances(
          testUser.uid,
        ),
      ).called(1);
      verifyNever(
        () => localTaskInstancesRepository.fetchTaskInstances(),
      );
      verify(
        () => remoteTaskInstancesRepository.updateTaskInstances(
          testUser.uid,
          updateTaskInstancesArg ?? any(),
        ),
      ).called(1);
      verifyNever(
        () => localTaskInstancesRepository.updateTaskInstances(
          any(),
        ),
      );
    }
  }

  group('TaskInstancesService', () {
    group('updateTaskInstances', () {
      test('null user, new task instance set in local repo', () async {
        // setup
        final testTaskInstance = createTestTaskInstance();
        final testTaskInstances = [testTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: testTaskInstances,
        );
        final taskInstancesService = makeTaskInstancesService();
        // run
        await taskInstancesService.updateTaskInstances(testTaskInstances);
        // verify
        verifyRepositories(
          user: null,
          updateTaskInstancesArg: testTaskInstances,
        );
      });
      test('non-null user, new task instance set in remote repo', () async {
        // setup
        final testTaskInstance = createTestTaskInstance();
        final testTaskInstances = [testTaskInstance];
        setUpRepositories(
          currentUserReturn: testUser,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: testTaskInstances,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.updateTaskInstances([testTaskInstance]);
        // verify
        verifyRepositories(
          user: testUser,
          updateTaskInstancesArg: testTaskInstances,
        );
      });
      test('null user, existing task instance set in local repo', () async {
        // setup
        final testTaskInstance = createTestTaskInstance();
        final testTaskInstances = [testTaskInstance];
        final updatedTestTaskInstance = testTaskInstance.copyWith(
          completed: true,
        );
        final updatedTestTaskInstances = [updatedTestTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: updatedTestTaskInstances,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.updateTaskInstances([updatedTestTaskInstance]);
        // verify
        verifyRepositories(
          user: null,
          updateTaskInstancesArg: updatedTestTaskInstances,
        );
      });
      test('non-null user, existing task instance set in remote repo',
          () async {
        // setup
        final testTaskInstance = createTestTaskInstance();
        final testTaskInstances = [testTaskInstance];
        final updatedTestTaskInstance = testTaskInstance.copyWith(
          completed: true,
        );
        final updatedTestTaskInstances = [updatedTestTaskInstance];
        setUpRepositories(
          currentUserReturn: testUser,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: updatedTestTaskInstances,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.updateTaskInstances([updatedTestTaskInstance]);
        // verify
        verifyRepositories(
          user: testUser,
          updateTaskInstancesArg: testTaskInstances,
        );
      });
    });

    group('createTasksInstances', () {
      test('null user, task NOT scheduled on date', () async {
        // setup
        final testDate = getDateNoTimeToday();
        final testTask = createTestTask().copyWith(
          frequency: Frequency.once,
          date: getDateNoTimeYesterday(),
        );
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: [],
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTasksInstances(testTask, [testDate]);
        // verify
        verifyNever(
          () => localTaskInstancesRepository.fetchTaskInstances(),
        );
        verifyNever(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        );
      });
      test('null user, task instance already exists for date', () async {
        // setup
        final testDate = getDateNoTimeToday();
        final testTask = createTestTask().copyWith(
          frequency: Frequency.once,
          date: testDate,
        );
        final testTaskInstance = createTestTaskInstance().copyWith(
          taskId: testTask.id,
          scheduledDate: testDate,
        );
        final testTaskInstances = [testTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: [],
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTasksInstances(testTask, [testDate]);
        // verify
        verifyNever(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        );
      });
      test('null user, date is before tasks createdOn date', () async {
        // setup
        final testDate = getDateNoTimeYesterday();
        final testTask = createTestTask().copyWith(
          frequency: Frequency.once,
          date: testDate,
        );
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: [],
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTasksInstances(testTask, [testDate]);
        // verify
        verifyNever(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        );
      });
      test('null user, once type task, scheduled', () async {
        // setup
        final testDate = getDateNoTimeToday();
        final testTask = createTestTask().copyWith(
          frequency: Frequency.once,
          date: testDate,
        );
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTasksInstances(testTask, [testDate]);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(1);
      });
      test('daily type task scheduled', () async {
        // setup
        final testDate = getDateNoTimeToday();
        final testTask = createTestTask().copyWith(
          frequency: Frequency.daily,
        );
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTasksInstances(testTask, [testDate]);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(1);
      });
      test('weekly type task scheduled', () async {
        // setup
        final testDate = getDateNoTimeToday();
        final testTask = createTestTask().copyWith(
          frequency: Frequency.weekly,
          weekdays: [
            ...Weekday.values.where((weekday) {
              return weekday.weekdayIndex == testDate.weekday;
            }),
          ],
        );
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTasksInstances(testTask, [testDate]);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(1);
      });
      test('monthly type task scheduled, first day of the month', () async {
        // setup
        final today = getDateNoTimeToday();
        final firstDayOfMonth = DateTime(
          today.year,
          today.month + 1,
          1,
        );
        final testTask = createTestTask().copyWith(
          frequency: Frequency.monthly,
          monthdays: [
            const Monthday(
              weekday: Weekday.day,
              ordinal: Ordinal.first,
            )
          ],
        );
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTasksInstances(testTask, [firstDayOfMonth]);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(1);
      });
      test('monthly type task scheduled, last day of the month', () async {
        // setup
        final today = getDateNoTimeToday();
        final lastDayOfMonth = DateTime(today.year, today.month + 1, 0);
        final testTask = createTestTask().copyWith(
          frequency: Frequency.monthly,
          monthdays: [
            const Monthday(
              weekday: Weekday.day,
              ordinal: Ordinal.last,
            )
          ],
        );
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTasksInstances(testTask, [lastDayOfMonth]);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(1);
      });
      test('monthly type task scheduled, second tuesday', () async {
        // setup
        final today = getDateNoTimeToday();
        final firstDayOfMonth = DateTime(
          today.year,
          today.month + 1,
          1,
        );

        DateTime testDate = firstDayOfMonth.copyWith();
        while (testDate.weekday != Weekday.tue.weekdayIndex) {
          testDate = testDate.add(const Duration(days: 1));
        }
        testDate = testDate.add(const Duration(days: 7));

        final testTask = createTestTask().copyWith(
          frequency: Frequency.monthly,
          monthdays: [
            const Monthday(
              weekday: Weekday.tue,
              ordinal: Ordinal.second,
            )
          ],
        );
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTasksInstances(testTask, [testDate]);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(1);
      });
      test('monthly type task scheduled, last sunday', () async {
        // setup
        final today = getDateNoTimeToday();
        final lastDayOfNextMonth = DateTime(today.year, today.month + 2, 0);
        DateTime testDate = lastDayOfNextMonth.copyWith();
        while (testDate.weekday != Weekday.sun.weekdayIndex) {
          testDate = testDate.subtract(const Duration(days: 1));
        }
        final testTask = createTestTask().copyWith(
          frequency: Frequency.monthly,
          monthdays: [
            const Monthday(
              weekday: Weekday.sun,
              ordinal: Ordinal.last,
            )
          ],
        );
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.createTasksInstances(testTask, [testDate]);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(1);
      });
    });

    group('removeTaskInstances', () {
      test('null user, task instances removed from local repo', () async {
        // setup
        final taskInstance1 = createTestTaskInstance(id: '1');
        final taskInstance2 = createTestTaskInstance(id: '2');
        final taskInstance3 = createTestTaskInstance(id: '3');
        final testTaskInstances = [
          taskInstance1,
          taskInstance2,
          taskInstance3,
        ];
        final updatedTestTaskInstances = [taskInstance3];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: updatedTestTaskInstances,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.deleteTaskInstances([
          taskInstance1.id,
          taskInstance2.id,
        ]);
        // verify
        verifyRepositories(
          user: null,
          updateTaskInstancesArg: updatedTestTaskInstances,
        );
      });
    });

    group('removeTasksInstances', () {
      test('null user, tasks instances removed from local repo', () async {
        // setup
        const testTaskId = 'removeId';
        final keepTaskInstance =
            createTestTaskInstance(id: '3').copyWith(taskId: 'keepId');
        final testTaskInstances = [
          createTestTaskInstance(id: '1').copyWith(taskId: testTaskId),
          createTestTaskInstance(id: '2').copyWith(taskId: testTaskId),
          keepTaskInstance,
        ];
        final updatedTestTaskInstances = [keepTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: updatedTestTaskInstances,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.deleteTasksInstances(testTaskId);
        // verify
        verifyRepositories(
          user: null,
          updateTaskInstancesArg: updatedTestTaskInstances,
        );
      });
    });

    group('changeTasksInstances', () {
      test('null user, task is new', () async {
        // setup
        final testTask = createTestTask();
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: [],
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.changeTasksInstances(testTask, null);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(1);
      });
      test('null user, task is NOT new, once date NO change', () async {
        // setup
        final testTask = createTestTask().copyWith(
          createdOn: getDateNoTimeYesterday(),
          date: getDateNoTimeToday(),
        );
        final testTaskOld = testTask.copyWith();
        final testTaskInstance = createTestTaskInstance(id: '1').copyWith(
          taskId: testTask.id,
          scheduledDate: getDateNoTimeYesterday(),
        );
        final testTaskInstances = [testTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.changeTasksInstances(testTask, testTaskOld);
        // verify
        verifyNever(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        );
      });
      test('null user, task is NOT new, once date change', () async {
        // setup
        final testTask = createTestTask().copyWith(
          createdOn: getDateNoTimeYesterday(),
          date: getDateNoTimeToday(),
        );
        final testTaskOld = testTask.copyWith(date: getDateNoTimeYesterday());
        final testTaskInstance = createTestTaskInstance(id: '1').copyWith(
          taskId: testTask.id,
          scheduledDate: getDateNoTimeYesterday(),
        );
        final testTaskInstances = [testTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.changeTasksInstances(testTask, testTaskOld);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(2);
      });
      test('null user, task is NOT new, daily NO change', () async {
        // setup
        final testTask = createTestTask().copyWith(
          createdOn: getDateNoTimeYesterday(),
          frequency: Frequency.daily,
        );
        final testTaskOld = testTask.copyWith();
        final testTaskInstance = createTestTaskInstance(id: '1').copyWith(
          taskId: testTask.id,
          scheduledDate: getDateNoTimeYesterday(),
        );
        final testTaskInstances = [testTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.changeTasksInstances(testTask, testTaskOld);
        // verify
        verifyNever(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        );
      });
      test('null user, task is NOT new, daily change', () async {
        // setup
        final testTask = createTestTask().copyWith(
          createdOn: getDateNoTimeYesterday(),
        );
        final testTaskOld = testTask.copyWith(frequency: Frequency.daily);
        final testTaskInstance1 = createTestTaskInstance(id: '1').copyWith(
          taskId: testTask.id,
          scheduledDate: getDateNoTimeYesterday(),
        );
        final testTaskInstance2 = createTestTaskInstance(id: '2').copyWith(
          taskId: testTask.id,
          scheduledDate: getDateNoTimeToday(),
        );
        final testTaskInstance3 = createTestTaskInstance(id: '3').copyWith(
          taskId: testTask.id,
          scheduledDate: getDateNoTimeTomorrow(),
        );
        final testTaskInstances = [
          testTaskInstance1,
          testTaskInstance2,
          testTaskInstance3,
        ];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.changeTasksInstances(testTask, testTaskOld);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(1);
      });
      test('null user, task is NOT new, weekly day NO change', () async {
        // setup
        final testTask = createTestTask().copyWith(
          createdOn: getDateNoTimeYesterday(),
          weekdays: [Weekday.sun],
          frequency: Frequency.weekly,
        );
        final testTaskOld = testTask.copyWith();
        final testTaskInstance = createTestTaskInstance(id: '1').copyWith(
          taskId: testTask.id,
          scheduledDate: getDateNoTimeYesterday(),
        );
        final testTaskInstances = [testTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.changeTasksInstances(testTask, testTaskOld);
        // verify
        verifyNever(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        );
      });
      test('null user, task is NOT new, weekly day change', () async {
        // setup
        final testTask = createTestTask().copyWith(
          createdOn: getDateNoTimeYesterday(),
          weekdays: [Weekday.sun],
          frequency: Frequency.weekly,
        );
        final testTaskOld = testTask.copyWith(weekdays: [Weekday.mon]);
        final testTaskInstance = createTestTaskInstance(id: '1').copyWith(
          taskId: testTask.id,
          scheduledDate: getDateNoTimeYesterday(),
        );
        final testTaskInstances = [testTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.changeTasksInstances(testTask, testTaskOld);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(1);
      });
      test('null user, task is NOT new, monthly day NO change', () async {
        // setup
        final testTask = createTestTask().copyWith(
          createdOn: getDateNoTimeYesterday(),
          monthdays: [
            const Monthday(weekday: Weekday.day, ordinal: Ordinal.first)
          ],
          frequency: Frequency.monthly,
        );
        final testTaskOld = testTask.copyWith();
        final testTaskInstance = createTestTaskInstance(id: '1').copyWith(
          taskId: testTask.id,
          scheduledDate: getDateNoTimeYesterday(),
        );
        final testTaskInstances = [testTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.changeTasksInstances(testTask, testTaskOld);
        // verify
        verifyNever(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        );
      });
      test('null user, task is NOT new, monthly day change', () async {
        // setup
        final testTask = createTestTask().copyWith(
          createdOn: getDateNoTimeYesterday(),
          monthdays: [
            const Monthday(weekday: Weekday.day, ordinal: Ordinal.first)
          ],
          frequency: Frequency.monthly,
        );
        final testTaskOld = testTask.copyWith(
          monthdays: [
            const Monthday(weekday: Weekday.day, ordinal: Ordinal.last)
          ],
        );
        final testTaskInstance = createTestTaskInstance(id: '1').copyWith(
          taskId: testTask.id,
          scheduledDate: getDateNoTimeYesterday(),
        );
        final testTaskInstances = [testTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.changeTasksInstances(testTask, testTaskOld);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(1);
      });
      test('null user, task is NOT new, untilAddressed change', () async {
        // setup
        final testTask = createTestTask().copyWith(
          createdOn: getDateNoTimeYesterday(),
          untilAddressed: true,
        );
        final testTaskOld = testTask.copyWith(untilAddressed: false);
        final testTaskInstance = createTestTaskInstance(id: '1').copyWith(
          taskId: testTask.id,
          scheduledDate: getDateNoTimeYesterday(),
        );
        final testTaskInstances = [testTaskInstance];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: null,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.changeTasksInstances(testTask, testTaskOld);
        // verify
        verify(
          () => localTaskInstancesRepository.updateTaskInstances(any()),
        ).called(2);
      });
    });

    group('updateTaskInstancesPriority', () {
      test('null user, local tasks instance priorities updated', () async {
        // setup
        final testTask1 = createTestTask(id: '1').copyWith(priority: 1);
        final testTask2 = createTestTask(id: '2').copyWith(priority: 2);
        final testTask3 = createTestTask(id: '3').copyWith(priority: 3);
        final testTasks = [
          testTask1,
          testTask2,
          testTask3,
        ];
        final testTask1Instance1 = createTestTaskInstance(id: '1').copyWith(
          taskId: testTask1.id,
          taskPriority: 0,
          scheduledDate: getDateNoTimeYesterday(),
        );
        final testTask1Instance2 = createTestTaskInstance(id: '2').copyWith(
          taskId: testTask1.id,
          taskPriority: 0,
        );
        final testTask1Instance3 = createTestTaskInstance(id: '3').copyWith(
          taskId: testTask1.id,
          taskPriority: 0,
          scheduledDate: getDateNoTimeTomorrow(),
        );
        final testTask2Instance1 = createTestTaskInstance(id: '4').copyWith(
          taskId: testTask2.id,
          taskPriority: 0,
        );
        final testTask3Instance1 = createTestTaskInstance(id: '5').copyWith(
          taskId: testTask3.id,
          taskPriority: 0,
        );
        final testTaskInstances = [
          testTask1Instance1,
          testTask1Instance2,
          testTask1Instance3,
          testTask2Instance1,
          testTask3Instance1,
        ];
        final updatedTestTaskInstances = [
          testTask1Instance1,
          testTask1Instance2.setTaskPriority(testTask1.priority),
          testTask1Instance3.setTaskPriority(testTask1.priority),
          testTask2Instance1.setTaskPriority(testTask2.priority),
          testTask3Instance1.setTaskPriority(testTask3.priority),
        ];
        setUpRepositories(
          currentUserReturn: null,
          fetchTaskInstancesReturn: testTaskInstances,
          updateTaskInstancesArg: updatedTestTaskInstances,
        );
        final tasksService = makeTaskInstancesService();
        // run
        await tasksService.updateTaskInstancesPriority(testTasks);
        // verify
        verifyRepositories(
          user: null,
          updateTaskInstancesArg: updatedTestTaskInstances,
        );
      });
    });
  });
}
