import 'package:firebase_core/firebase_core.dart';
import 'package:flow/src/features/routines/data/local/local_routines_repository.dart';
import 'package:flow/src/features/routines/data/local/sembast_routines_repository.dart';
import 'package:flow/src/features/routines/data/remote/remote_routine_repository.dart';
import 'package:flow/src/features/routines/data/remote/test_remote_routines_repository.dart';
import 'package:flow/src/features/task_instances/application/task_instances_sync_service.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/local/sembast_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/test_remote_task_instances_repository.dart';
import 'package:flow/src/features/tasks/application/tasks_sync_service.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/local/sembast_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/test_remote_tasks_repository.dart';
import 'package:flow/src/flow_app.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // * Remove # from URLs on web
  usePathUrlStrategy();
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers();
  // * Create local repositories
  final sembastTasksRepository = await SembastTasksRepository.makeDefault();
  final sembastTaskInstancesRepository =
      await SembastTaskInstancesRepository.makeDefault();
  final sembastRoutinesRepository =
      await SembastRoutinesRepository.makeDefault();
  // * Create remote repositories
  final remoteTasksRepository = TestRemoteTasksRepository();
  final remoteTaskInstancesRepository = TestRemoteTaskInstancesRepository();
  final remoteRoutinesRepository = TestRemoteRoutinesRepository();
  // * Create provider container to override providers
  final providerContainer = ProviderContainer(
    overrides: [
      localTasksRepositoryProvider.overrideWithValue(
        sembastTasksRepository,
      ),
      remoteTasksRepositoryProvider.overrideWithValue(
        remoteTasksRepository,
      ),
      localTaskInstancesRepositoryProvider.overrideWithValue(
        sembastTaskInstancesRepository,
      ),
      remoteTaskInstancesRepositoryProvider.overrideWithValue(
        remoteTaskInstancesRepository,
      ),
      localRoutinesRepositoryProvider.overrideWithValue(
        sembastRoutinesRepository,
      ),
      remoteRoutinesRepositoryProvider.overrideWithValue(
        remoteRoutinesRepository,
      ),
    ],
  );
  // * Initialize Sync listeners
  providerContainer.read(tasksSyncServiceProvider);
  providerContainer.read(taskInstancesSyncServiceProvider);
  // * Entry point of the app
  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const FlowApp(),
    ),
  );
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
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
