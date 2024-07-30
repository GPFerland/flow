// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_task_instances_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localTaskInstancesRepositoryHash() =>
    r'c9c0c67dda58adae6715c06c59105766500523ff';

/// See also [localTaskInstancesRepository].
@ProviderFor(localTaskInstancesRepository)
final localTaskInstancesRepositoryProvider =
    Provider<LocalTaskInstancesRepository>.internal(
  localTaskInstancesRepository,
  name: r'localTaskInstancesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localTaskInstancesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalTaskInstancesRepositoryRef
    = ProviderRef<LocalTaskInstancesRepository>;
String _$localTaskInstancesFutureHash() =>
    r'442c9fb794432561585c8fc27e6f697ed920fcd2';

/// See also [localTaskInstancesFuture].
@ProviderFor(localTaskInstancesFuture)
final localTaskInstancesFutureProvider =
    AutoDisposeFutureProvider<List<TaskInstance>>.internal(
  localTaskInstancesFuture,
  name: r'localTaskInstancesFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localTaskInstancesFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalTaskInstancesFutureRef
    = AutoDisposeFutureProviderRef<List<TaskInstance>>;
String _$localTaskInstanceFutureHash() =>
    r'bc61a1f66e404490db5f2b4d35903c251146afd4';

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

/// See also [localTaskInstanceFuture].
@ProviderFor(localTaskInstanceFuture)
const localTaskInstanceFutureProvider = LocalTaskInstanceFutureFamily();

/// See also [localTaskInstanceFuture].
class LocalTaskInstanceFutureFamily extends Family<AsyncValue<TaskInstance?>> {
  /// See also [localTaskInstanceFuture].
  const LocalTaskInstanceFutureFamily();

  /// See also [localTaskInstanceFuture].
  LocalTaskInstanceFutureProvider call(
    String taskInstanceId,
  ) {
    return LocalTaskInstanceFutureProvider(
      taskInstanceId,
    );
  }

  @override
  LocalTaskInstanceFutureProvider getProviderOverride(
    covariant LocalTaskInstanceFutureProvider provider,
  ) {
    return call(
      provider.taskInstanceId,
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
  String? get name => r'localTaskInstanceFutureProvider';
}

/// See also [localTaskInstanceFuture].
class LocalTaskInstanceFutureProvider
    extends AutoDisposeFutureProvider<TaskInstance?> {
  /// See also [localTaskInstanceFuture].
  LocalTaskInstanceFutureProvider(
    String taskInstanceId,
  ) : this._internal(
          (ref) => localTaskInstanceFuture(
            ref as LocalTaskInstanceFutureRef,
            taskInstanceId,
          ),
          from: localTaskInstanceFutureProvider,
          name: r'localTaskInstanceFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$localTaskInstanceFutureHash,
          dependencies: LocalTaskInstanceFutureFamily._dependencies,
          allTransitiveDependencies:
              LocalTaskInstanceFutureFamily._allTransitiveDependencies,
          taskInstanceId: taskInstanceId,
        );

  LocalTaskInstanceFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskInstanceId,
  }) : super.internal();

  final String taskInstanceId;

  @override
  Override overrideWith(
    FutureOr<TaskInstance?> Function(LocalTaskInstanceFutureRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocalTaskInstanceFutureProvider._internal(
        (ref) => create(ref as LocalTaskInstanceFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskInstanceId: taskInstanceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TaskInstance?> createElement() {
    return _LocalTaskInstanceFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalTaskInstanceFutureProvider &&
        other.taskInstanceId == taskInstanceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskInstanceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LocalTaskInstanceFutureRef
    on AutoDisposeFutureProviderRef<TaskInstance?> {
  /// The parameter `taskInstanceId` of this provider.
  String get taskInstanceId;
}

class _LocalTaskInstanceFutureProviderElement
    extends AutoDisposeFutureProviderElement<TaskInstance?>
    with LocalTaskInstanceFutureRef {
  _LocalTaskInstanceFutureProviderElement(super.provider);

  @override
  String get taskInstanceId =>
      (origin as LocalTaskInstanceFutureProvider).taskInstanceId;
}

String _$localTaskInstancesStreamHash() =>
    r'dece7558334818133b71e64f39a94da1401d4247';

/// See also [localTaskInstancesStream].
@ProviderFor(localTaskInstancesStream)
final localTaskInstancesStreamProvider =
    AutoDisposeStreamProvider<List<TaskInstance>>.internal(
  localTaskInstancesStream,
  name: r'localTaskInstancesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localTaskInstancesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalTaskInstancesStreamRef
    = AutoDisposeStreamProviderRef<List<TaskInstance>>;
String _$localTaskInstanceStreamHash() =>
    r'0b0cbdf02a39d6e8e1994c821f64701c1c556474';

/// See also [localTaskInstanceStream].
@ProviderFor(localTaskInstanceStream)
const localTaskInstanceStreamProvider = LocalTaskInstanceStreamFamily();

/// See also [localTaskInstanceStream].
class LocalTaskInstanceStreamFamily extends Family<AsyncValue<TaskInstance?>> {
  /// See also [localTaskInstanceStream].
  const LocalTaskInstanceStreamFamily();

  /// See also [localTaskInstanceStream].
  LocalTaskInstanceStreamProvider call(
    String taskInstanceId,
  ) {
    return LocalTaskInstanceStreamProvider(
      taskInstanceId,
    );
  }

  @override
  LocalTaskInstanceStreamProvider getProviderOverride(
    covariant LocalTaskInstanceStreamProvider provider,
  ) {
    return call(
      provider.taskInstanceId,
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
  String? get name => r'localTaskInstanceStreamProvider';
}

/// See also [localTaskInstanceStream].
class LocalTaskInstanceStreamProvider
    extends AutoDisposeStreamProvider<TaskInstance?> {
  /// See also [localTaskInstanceStream].
  LocalTaskInstanceStreamProvider(
    String taskInstanceId,
  ) : this._internal(
          (ref) => localTaskInstanceStream(
            ref as LocalTaskInstanceStreamRef,
            taskInstanceId,
          ),
          from: localTaskInstanceStreamProvider,
          name: r'localTaskInstanceStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$localTaskInstanceStreamHash,
          dependencies: LocalTaskInstanceStreamFamily._dependencies,
          allTransitiveDependencies:
              LocalTaskInstanceStreamFamily._allTransitiveDependencies,
          taskInstanceId: taskInstanceId,
        );

  LocalTaskInstanceStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskInstanceId,
  }) : super.internal();

  final String taskInstanceId;

  @override
  Override overrideWith(
    Stream<TaskInstance?> Function(LocalTaskInstanceStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocalTaskInstanceStreamProvider._internal(
        (ref) => create(ref as LocalTaskInstanceStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskInstanceId: taskInstanceId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<TaskInstance?> createElement() {
    return _LocalTaskInstanceStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalTaskInstanceStreamProvider &&
        other.taskInstanceId == taskInstanceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskInstanceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LocalTaskInstanceStreamRef
    on AutoDisposeStreamProviderRef<TaskInstance?> {
  /// The parameter `taskInstanceId` of this provider.
  String get taskInstanceId;
}

class _LocalTaskInstanceStreamProviderElement
    extends AutoDisposeStreamProviderElement<TaskInstance?>
    with LocalTaskInstanceStreamRef {
  _LocalTaskInstanceStreamProviderElement(super.provider);

  @override
  String get taskInstanceId =>
      (origin as LocalTaskInstanceStreamProvider).taskInstanceId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
