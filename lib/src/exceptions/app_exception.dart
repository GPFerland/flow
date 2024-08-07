import 'package:flow/src/localization/string_hardcoded.dart';

/// Base class for all all client-side errors that can be generated by the app
sealed class AppException implements Exception {
  AppException(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => message;
}

/// Tasks
class TasksCreateFailedException extends AppException {
  TasksCreateFailedException()
      : super(
          'tasks-create-failed',
          'An error has occurred while creating the task'.hardcoded,
        );
}

class TasksSyncFailedException extends AppException {
  TasksSyncFailedException()
      : super(
          'tasks-sync-failed',
          'An error has occurred while syncing the tasks'.hardcoded,
        );
}

/// Task Instances
class TaskInstancesCreateFailedException extends AppException {
  TaskInstancesCreateFailedException()
      : super(
          'task-instances-create-failed',
          'An error has occurred while creating the task instance'.hardcoded,
        );
}

class TaskInstancesSyncFailedException extends AppException {
  TaskInstancesSyncFailedException()
      : super(
          'task-instances-sync-failed',
          'An error has occurred while syncing the task instances'.hardcoded,
        );
}
