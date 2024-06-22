import 'package:flow/src/constants/test_tasks.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../tasks_robot.dart';

void main() {
  const testTaskTitle = 'Task Title';
  // const testTaskIcon = Icons.abc;
  // const testTaskColor = Colors.blue;
  // const testTaskDescription = 'Task Description';
  // const textTaskUntilComplete = true;

  late MockAuthRepository authRepository;
  late MockLocalTasksRepository localTasksRepository;
  late MockRemoteTasksRepository remoteTasksRepository;

  setUpAll(() {
    registerFallbackValue(
      Tasks(tasksList: []),
    );
  });

  setUp(
    () {
      authRepository = MockAuthRepository();
      localTasksRepository = MockLocalTasksRepository();
      remoteTasksRepository = MockRemoteTasksRepository();
    },
  );

  group(
    'create task',
    () {
      testWidgets(
        '''
        Given Create Task screen is opened
        When the title field is not filled out
        Then setTasks is not called
        And title validation error is shown
        ''',
        (tester) async {
          final r = TasksRobot(tester);
          await r.pumpTaskForm(
            authRepository: authRepository,
            localTasksRepository: localTasksRepository,
            remoteTasksRepository: remoteTasksRepository,
          );
          await r.tapCreateButton();
          r.expectTitleValidationErrorFound();
          verifyNever(
            () => localTasksRepository.setTasks(any()),
          );
        },
      );

      testWidgets(
        '''
        Given Create Task screen is opened
        When the title field is filled out
        Then setTasks is called
        ''',
        (tester) async {
          final r = TasksRobot(tester);
          when(() => localTasksRepository.fetchTasks()).thenAnswer(
            (_) => Future.value(kTestTasks),
          );
          when(() => localTasksRepository.setTasks(any())).thenAnswer(
            (_) => Future.delayed(const Duration(seconds: 1)),
          );
          await r.pumpTaskForm(
            authRepository: authRepository,
            localTasksRepository: localTasksRepository,
            remoteTasksRepository: remoteTasksRepository,
          );
          await r.enterTitle(testTaskTitle);
          await r.tapCreateButton();
          r.expectTitleValidationErrorNotFound();
          r.expectCircularProgressIndicator();
          r.expectErrorAlertNotFound();
          verify(
            () => localTasksRepository.setTasks(any()),
          );
        },
      );
    },
  );
}
