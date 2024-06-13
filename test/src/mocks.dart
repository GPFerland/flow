import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements TestAuthRepository {}

class MockLocalTasksRepository extends Mock implements LocalTasksRepository {}

class MockRemoteTasksRepository extends Mock implements RemoteTasksRepository {}
