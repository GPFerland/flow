import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/check_list/data/task_display_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository_fake.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository_fake.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository_fake.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository_fake.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockDateRepository extends Mock implements DateRepository {}

class MockTaskDisplayRepository extends Mock implements TaskDisplayRepository {}

class MockLocalTasksRepository extends Mock
    implements FakeLocalTasksRepository {}

class MockRemoteTasksRepository extends Mock
    implements FakeRemoteTasksRepository {}

class MockTasksService extends Mock implements TasksService {}

class MockLocalTaskInstancesRepository extends Mock
    implements FakeLocalTaskInstancesRepository {}

class MockRemoteTaskInstancesRepository extends Mock
    implements FakeRemoteTaskInstancesRepository {}

class MockTaskInstancesService extends Mock implements TaskInstancesService {}

class MockGoRouter extends Mock implements GoRouter {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}
