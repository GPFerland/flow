import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/data/local/test_local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/test_remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/presentation/task_form/task_form_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements TestAuthRepository {}

class MockLocalTasksRepository extends Mock
    implements TestLocalTasksRepository {}

class MockRemoteTasksRepository extends Mock
    implements TestRemoteTasksRepository {}

class MockTasksService extends Mock implements TasksService {}

class MockTaskFormController extends Mock implements TaskFormController {}
