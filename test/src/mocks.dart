import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/check_list/data/task_display_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/data/local/test_local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/test_remote_task_instances_repository.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/data/local/test_local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/test_remote_tasks_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements TestAuthRepository {}

class MockDateRepository extends Mock implements DateRepository {}

class MockTaskDisplayRepository extends Mock implements TaskDisplayRepository {}

class MockLocalTasksRepository extends Mock
    implements TestLocalTasksRepository {}

class MockRemoteTasksRepository extends Mock
    implements TestRemoteTasksRepository {}

class MockTasksService extends Mock implements TasksService {}

class MockLocalTaskInstancesRepository extends Mock
    implements TestLocalTaskInstancesRepository {}

class MockRemoteTaskInstancesRepository extends Mock
    implements TestRemoteTaskInstancesRepository {}

class MockTaskInstancesService extends Mock implements TaskInstancesService {}

class MockGoRouter extends Mock implements GoRouter {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}
