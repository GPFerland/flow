// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tasksServiceHash() => r'e9375d085a1f35fa3532b5e378f0b1e1547ed227';

/// See also [tasksService].
@ProviderFor(tasksService)
final tasksServiceProvider = Provider<TasksService>.internal(
  tasksService,
  name: r'tasksServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tasksServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TasksServiceRef = ProviderRef<TasksService>;
String _$taskFutureHash() => r'018bae57b06f0f5c248c69c052b423ab23ccd50a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [taskFuture].
@ProviderFor(taskFuture)
const taskFutureProvider = TaskFutureFamily();

/// See also [taskFuture].
class TaskFutureFamily extends Family<AsyncValue<Task?>> {
  /// See also [taskFuture].
  const TaskFutureFamily();

  /// See also [taskFuture].
  TaskFutureProvider call(
    String taskId,
  ) {
    return TaskFutureProvider(
      taskId,
    );
  }

  @override
  TaskFutureProvider getProviderOverride(
    covariant TaskFutureProvider provider,
  ) {
    return call(
      provider.taskId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskFutureProvider';
}

/// See also [taskFuture].
class TaskFutureProvider extends AutoDisposeFutureProvider<Task?> {
  /// See also [taskFuture].
  TaskFutureProvider(
    String taskId,
  ) : this._internal(
          (ref) => taskFuture(
            ref as TaskFutureRef,
            taskId,
          ),
          from: taskFutureProvider,
          name: r'taskFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskFutureHash,
          dependencies: TaskFutureFamily._dependencies,
          allTransitiveDependencies:
              TaskFutureFamily._allTransitiveDependencies,
          taskId: taskId,
        );

  TaskFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
  }) : super.internal();

  final String taskId;

  @override
  Override overrideWith(
    FutureOr<Task?> Function(TaskFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskFutureProvider._internal(
        (ref) => create(ref as TaskFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Task?> createElement() {
    return _TaskFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskFutureProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TaskFutureRef on AutoDisposeFutureProviderRef<Task?> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _TaskFutureProviderElement extends AutoDisposeFutureProviderElement<Task?>
    with TaskFutureRef {
  _TaskFutureProviderElement(super.provider);

  @override
  String get taskId => (origin as TaskFutureProvider).taskId;
}

String _$tasksStreamHash() => r'6a2cba94c92cc1d5eb8b69bbe0bad8a28ca7d470';

/// See also [tasksStream].
@ProviderFor(tasksStream)
final tasksStreamProvider = AutoDisposeStreamProvider<List<Task>>.internal(
  tasksStream,
  name: r'tasksStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tasksStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TasksStreamRef = AutoDisposeStreamProviderRef<List<Task>>;
String _$taskStreamHash() => r'c502021ff1c8460c8f2980d423b8628c0b073315';

/// See also [taskStream].
@ProviderFor(taskStream)
const taskStreamProvider = TaskStreamFamily();

/// See also [taskStream].
class TaskStreamFamily extends Family<AsyncValue<Task?>> {
  /// See also [taskStream].
  const TaskStreamFamily();

  /// See also [taskStream].
  TaskStreamProvider call(
    String taskId,
  ) {
    return TaskStreamProvider(
      taskId,
    );
  }

  @override
  TaskStreamProvider getProviderOverride(
    covariant TaskStreamProvider provider,
  ) {
    return call(
      provider.taskId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskStreamProvider';
}

/// See also [taskStream].
class TaskStreamProvider extends AutoDisposeStreamProvider<Task?> {
  /// See also [taskStream].
  TaskStreamProvider(
    String taskId,
  ) : this._internal(
          (ref) => taskStream(
            ref as TaskStreamRef,
            taskId,
          ),
          from: taskStreamProvider,
          name: r'taskStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskStreamHash,
          dependencies: TaskStreamFamily._dependencies,
          allTransitiveDependencies:
              TaskStreamFamily._allTransitiveDependencies,
          taskId: taskId,
        );

  TaskStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskId,
  }) : super.internal();

  final String taskId;

  @override
  Override overrideWith(
    Stream<Task?> Function(TaskStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskStreamProvider._internal(
        (ref) => create(ref as TaskStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Task?> createElement() {
    return _TaskStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskStreamProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TaskStreamRef on AutoDisposeStreamProviderRef<Task?> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _TaskStreamProviderElement extends AutoDisposeStreamProviderElement<Task?>
    with TaskStreamRef {
  _TaskStreamProviderElement(super.provider);

  @override
  String get taskId => (origin as TaskStreamProvider).taskId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
