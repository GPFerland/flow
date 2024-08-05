import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/src/exceptions/async_error_logger.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/local/local_task_instances_repository_production.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository_production.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/local/local_tasks_repository_production.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository_production.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Creates the top-level [ProviderContainer] by overriding providers with fake
/// repositories only. This is useful for testing purposes and for running the
/// app with a "fake" backend.
///
/// Note: all repositories needed by the app can be accessed via providers.
/// Some of these providers throw an [UnimplementedError] by default.
///
/// Example:
/// ```dart
/// @Riverpod(keepAlive: true)
/// LocalTasksRepository localTasksRepository(LocalTasksRepositoryRef ref) {
///   throw UnimplementedError();
/// }
/// ```
///
/// As a result, this method does two things:
/// - create and configure the repositories as desired
/// - override the default implementations with a list of "overrides"
Future<ProviderContainer> createProductionProviderContainer() async {
  final localTasksRepository =
      await ProductionLocalTasksRepository.makeDefault();
  final localTaskInstancesRepository =
      await ProductionLocalTaskInstancesRepository.makeDefault();
  final remoteTasksRepository = ProductionRemoteTasksRepository(
    firestore: FirebaseFirestore.instance,
  );
  final remoteTaskInstancesRepository = ProductionRemoteTaskInstancesRepository(
    firestore: FirebaseFirestore.instance,
  );

  return ProviderContainer(
    overrides: [
      localTasksRepositoryProvider.overrideWithValue(
        localTasksRepository,
      ),
      remoteTasksRepositoryProvider.overrideWithValue(
        remoteTasksRepository,
      ),
      localTaskInstancesRepositoryProvider.overrideWithValue(
        localTaskInstancesRepository,
      ),
      remoteTaskInstancesRepositoryProvider.overrideWithValue(
        remoteTaskInstancesRepository,
      ),
    ],
    observers: [AsyncErrorLogger()],
  );
}
