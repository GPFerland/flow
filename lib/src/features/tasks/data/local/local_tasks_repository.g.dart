// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_tasks_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localTasksRepositoryHash() =>
    r'4f6e9693c216397445366b786d56d743ac1a8cc0';

/// See also [localTasksRepository].
@ProviderFor(localTasksRepository)
final localTasksRepositoryProvider = Provider<LocalTasksRepository>.internal(
  localTasksRepository,
  name: r'localTasksRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localTasksRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalTasksRepositoryRef = ProviderRef<LocalTasksRepository>;
String _$localTaskFutureHash() => r'3a798b0693ea460676b44bcc2dbf0859cf63f19f';

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

/// See also [localTaskFuture].
@ProviderFor(localTaskFuture)
const localTaskFutureProvider = LocalTaskFutureFamily();

/// See also [localTaskFuture].
class LocalTaskFutureFamily extends Family<AsyncValue<Task?>> {
  /// See also [localTaskFuture].
  const LocalTaskFutureFamily();

  /// See also [localTaskFuture].
  LocalTaskFutureProvider call(
    String taskId,
  ) {
    return LocalTaskFutureProvider(
      taskId,
    );
  }

  @override
  LocalTaskFutureProvider getProviderOverride(
    covariant LocalTaskFutureProvider provider,
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
  String? get name => r'localTaskFutureProvider';
}

/// See also [localTaskFuture].
class LocalTaskFutureProvider extends AutoDisposeFutureProvider<Task?> {
  /// See also [localTaskFuture].
  LocalTaskFutureProvider(
    String taskId,
  ) : this._internal(
          (ref) => localTaskFuture(
            ref as LocalTaskFutureRef,
            taskId,
          ),
          from: localTaskFutureProvider,
          name: r'localTaskFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$localTaskFutureHash,
          dependencies: LocalTaskFutureFamily._dependencies,
          allTransitiveDependencies:
              LocalTaskFutureFamily._allTransitiveDependencies,
          taskId: taskId,
        );

  LocalTaskFutureProvider._internal(
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
    FutureOr<Task?> Function(LocalTaskFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocalTaskFutureProvider._internal(
        (ref) => create(ref as LocalTaskFutureRef),
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
    return _LocalTaskFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalTaskFutureProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LocalTaskFutureRef on AutoDisposeFutureProviderRef<Task?> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _LocalTaskFutureProviderElement
    extends AutoDisposeFutureProviderElement<Task?> with LocalTaskFutureRef {
  _LocalTaskFutureProviderElement(super.provider);

  @override
  String get taskId => (origin as LocalTaskFutureProvider).taskId;
}

String _$localTasksFutureHash() => r'055fcbd04a7294f63ae8edc7ed14c68f1814fce8';

/// See also [localTasksFuture].
@ProviderFor(localTasksFuture)
final localTasksFutureProvider = AutoDisposeFutureProvider<List<Task>>.internal(
  localTasksFuture,
  name: r'localTasksFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localTasksFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalTasksFutureRef = AutoDisposeFutureProviderRef<List<Task>>;
String _$localTaskStreamHash() => r'929a2b2575b6f2604cc5cc42c25b5a4f62930d70';

/// See also [localTaskStream].
@ProviderFor(localTaskStream)
const localTaskStreamProvider = LocalTaskStreamFamily();

/// See also [localTaskStream].
class LocalTaskStreamFamily extends Family<AsyncValue<Task?>> {
  /// See also [localTaskStream].
  const LocalTaskStreamFamily();

  /// See also [localTaskStream].
  LocalTaskStreamProvider call(
    String taskId,
  ) {
    return LocalTaskStreamProvider(
      taskId,
    );
  }

  @override
  LocalTaskStreamProvider getProviderOverride(
    covariant LocalTaskStreamProvider provider,
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
  String? get name => r'localTaskStreamProvider';
}

/// See also [localTaskStream].
class LocalTaskStreamProvider extends AutoDisposeStreamProvider<Task?> {
  /// See also [localTaskStream].
  LocalTaskStreamProvider(
    String taskId,
  ) : this._internal(
          (ref) => localTaskStream(
            ref as LocalTaskStreamRef,
            taskId,
          ),
          from: localTaskStreamProvider,
          name: r'localTaskStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$localTaskStreamHash,
          dependencies: LocalTaskStreamFamily._dependencies,
          allTransitiveDependencies:
              LocalTaskStreamFamily._allTransitiveDependencies,
          taskId: taskId,
        );

  LocalTaskStreamProvider._internal(
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
    Stream<Task?> Function(LocalTaskStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocalTaskStreamProvider._internal(
        (ref) => create(ref as LocalTaskStreamRef),
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
    return _LocalTaskStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalTaskStreamProvider && other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LocalTaskStreamRef on AutoDisposeStreamProviderRef<Task?> {
  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _LocalTaskStreamProviderElement
    extends AutoDisposeStreamProviderElement<Task?> with LocalTaskStreamRef {
  _LocalTaskStreamProviderElement(super.provider);

  @override
  String get taskId => (origin as LocalTaskStreamProvider).taskId;
}

String _$localTasksStreamHash() => r'c27bd6a1bd9dd4a5f91a0be3e23bd895b6af387c';

/// See also [localTasksStream].
@ProviderFor(localTasksStream)
final localTasksStreamProvider = AutoDisposeStreamProvider<List<Task>>.internal(
  localTasksStream,
  name: r'localTasksStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localTasksStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalTasksStreamRef = AutoDisposeStreamProviderRef<List<Task>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
