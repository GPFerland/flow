import 'package:flow/src/exceptions/async_error_logger.dart';
import 'package:flow/src/exceptions/error_logger.dart';
import 'package:flow/src/features/task_instances/application/task_instances_creation_service.dart';
import 'package:flow/src/features/task_instances/application/task_instances_sync_service.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/local/sembast_local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/test_remote_task_instances_repository.dart';
import 'package:flow/src/features/tasks/application/tasks_sync_service.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/local/sembast_local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/test_remote_tasks_repository.dart';
import 'package:flow/src/flow_app.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // * Remove # from URLs on web
  usePathUrlStrategy();
  // * Create local repositories
  final sembastLocalTasksRepository =
      await SembastLocalTasksRepository.makeDefault();
  final sembastLocalTaskInstancesRepository =
      await SembastLocalTaskInstancesRepository.makeDefault();
  // * Create remote repositories
  final testRemoteTasksRepository = TestRemoteTasksRepository();
  final testRemoteTaskInstancesRepository = TestRemoteTaskInstancesRepository();
  // * Create provider container to override providers
  final providerContainer = ProviderContainer(
    overrides: [
      localTasksRepositoryProvider.overrideWithValue(
        sembastLocalTasksRepository,
      ),
      remoteTasksRepositoryProvider.overrideWithValue(
        testRemoteTasksRepository,
      ),
      localTaskInstancesRepositoryProvider.overrideWithValue(
        sembastLocalTaskInstancesRepository,
      ),
      remoteTaskInstancesRepositoryProvider.overrideWithValue(
        testRemoteTaskInstancesRepository,
      ),
    ],
    observers: [AsyncErrorLogger()],
  );
  // * Initialize sync and creation listeners
  providerContainer.read(tasksSyncServiceProvider);
  providerContainer.read(taskInstancesSyncServiceProvider);
  providerContainer.read(taskInstancesCreationServiceProvider);
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  final errorLogger = providerContainer.read(errorLoggerProvider);
  registerErrorHandlers(errorLogger);
  // * Entry point of the app
  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const FlowApp(),
    ),
  );
}

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'.hardcoded),
      ),
      body: Center(
        child: Text(details.toString()),
      ),
    );
  };
}
