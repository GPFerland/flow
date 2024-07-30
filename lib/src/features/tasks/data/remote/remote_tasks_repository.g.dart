// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_tasks_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$remoteTasksRepositoryHash() =>
    r'18d96264b9f0420b8e157b93e3429688963e2a88';

/// See also [remoteTasksRepository].
@ProviderFor(remoteTasksRepository)
final remoteTasksRepositoryProvider = Provider<RemoteTasksRepository>.internal(
  remoteTasksRepository,
  name: r'remoteTasksRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remoteTasksRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RemoteTasksRepositoryRef = ProviderRef<RemoteTasksRepository>;
String _$remoteTasksFutureHash() => r'36da38ef3dcb1a2de42d6c80a05b2a926e69f4e2';

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

/// See also [remoteTasksFuture].
@ProviderFor(remoteTasksFuture)
const remoteTasksFutureProvider = RemoteTasksFutureFamily();

/// See also [remoteTasksFuture].
class RemoteTasksFutureFamily extends Family<AsyncValue<List<Task>>> {
  /// See also [remoteTasksFuture].
  const RemoteTasksFutureFamily();

  /// See also [remoteTasksFuture].
  RemoteTasksFutureProvider call(
    String uid,
  ) {
    return RemoteTasksFutureProvider(
      uid,
    );
  }

  @override
  RemoteTasksFutureProvider getProviderOverride(
    covariant RemoteTasksFutureProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'remoteTasksFutureProvider';
}

/// See also [remoteTasksFuture].
class RemoteTasksFutureProvider extends AutoDisposeFutureProvider<List<Task>> {
  /// See also [remoteTasksFuture].
  RemoteTasksFutureProvider(
    String uid,
  ) : this._internal(
          (ref) => remoteTasksFuture(
            ref as RemoteTasksFutureRef,
            uid,
          ),
          from: remoteTasksFutureProvider,
          name: r'remoteTasksFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$remoteTasksFutureHash,
          dependencies: RemoteTasksFutureFamily._dependencies,
          allTransitiveDependencies:
              RemoteTasksFutureFamily._allTransitiveDependencies,
          uid: uid,
        );

  RemoteTasksFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    FutureOr<List<Task>> Function(RemoteTasksFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoteTasksFutureProvider._internal(
        (ref) => create(ref as RemoteTasksFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Task>> createElement() {
    return _RemoteTasksFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoteTasksFutureProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RemoteTasksFutureRef on AutoDisposeFutureProviderRef<List<Task>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _RemoteTasksFutureProviderElement
    extends AutoDisposeFutureProviderElement<List<Task>>
    with RemoteTasksFutureRef {
  _RemoteTasksFutureProviderElement(super.provider);

  @override
  String get uid => (origin as RemoteTasksFutureProvider).uid;
}

String _$remoteTaskFutureHash() => r'bde44a8b52f9cdde6f67bd17c5731b327bcd02d8';

/// See also [remoteTaskFuture].
@ProviderFor(remoteTaskFuture)
const remoteTaskFutureProvider = RemoteTaskFutureFamily();

/// See also [remoteTaskFuture].
class RemoteTaskFutureFamily extends Family<AsyncValue<Task?>> {
  /// See also [remoteTaskFuture].
  const RemoteTaskFutureFamily();

  /// See also [remoteTaskFuture].
  RemoteTaskFutureProvider call(
    String uid,
    String taskId,
  ) {
    return RemoteTaskFutureProvider(
      uid,
      taskId,
    );
  }

  @override
  RemoteTaskFutureProvider getProviderOverride(
    covariant RemoteTaskFutureProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'remoteTaskFutureProvider';
}

/// See also [remoteTaskFuture].
class RemoteTaskFutureProvider extends AutoDisposeFutureProvider<Task?> {
  /// See also [remoteTaskFuture].
  RemoteTaskFutureProvider(
    String uid,
    String taskId,
  ) : this._internal(
          (ref) => remoteTaskFuture(
            ref as RemoteTaskFutureRef,
            uid,
            taskId,
          ),
          from: remoteTaskFutureProvider,
          name: r'remoteTaskFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$remoteTaskFutureHash,
          dependencies: RemoteTaskFutureFamily._dependencies,
          allTransitiveDependencies:
              RemoteTaskFutureFamily._allTransitiveDependencies,
          uid: uid,
          taskId: taskId,
        );

  RemoteTaskFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
    required this.taskId,
  }) : super.internal();

  final String uid;
  final String taskId;

  @override
  Override overrideWith(
    FutureOr<Task?> Function(RemoteTaskFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoteTaskFutureProvider._internal(
        (ref) => create(ref as RemoteTaskFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Task?> createElement() {
    return _RemoteTaskFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoteTaskFutureProvider &&
        other.uid == uid &&
        other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RemoteTaskFutureRef on AutoDisposeFutureProviderRef<Task?> {
  /// The parameter `uid` of this provider.
  String get uid;

  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _RemoteTaskFutureProviderElement
    extends AutoDisposeFutureProviderElement<Task?> with RemoteTaskFutureRef {
  _RemoteTaskFutureProviderElement(super.provider);

  @override
  String get uid => (origin as RemoteTaskFutureProvider).uid;
  @override
  String get taskId => (origin as RemoteTaskFutureProvider).taskId;
}

String _$remoteTasksStreamHash() => r'a5cea7f781ecb025ab23c3c281959d3c0b5175ff';

/// See also [remoteTasksStream].
@ProviderFor(remoteTasksStream)
const remoteTasksStreamProvider = RemoteTasksStreamFamily();

/// See also [remoteTasksStream].
class RemoteTasksStreamFamily extends Family<AsyncValue<List<Task>>> {
  /// See also [remoteTasksStream].
  const RemoteTasksStreamFamily();

  /// See also [remoteTasksStream].
  RemoteTasksStreamProvider call(
    String uid,
  ) {
    return RemoteTasksStreamProvider(
      uid,
    );
  }

  @override
  RemoteTasksStreamProvider getProviderOverride(
    covariant RemoteTasksStreamProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'remoteTasksStreamProvider';
}

/// See also [remoteTasksStream].
class RemoteTasksStreamProvider extends AutoDisposeStreamProvider<List<Task>> {
  /// See also [remoteTasksStream].
  RemoteTasksStreamProvider(
    String uid,
  ) : this._internal(
          (ref) => remoteTasksStream(
            ref as RemoteTasksStreamRef,
            uid,
          ),
          from: remoteTasksStreamProvider,
          name: r'remoteTasksStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$remoteTasksStreamHash,
          dependencies: RemoteTasksStreamFamily._dependencies,
          allTransitiveDependencies:
              RemoteTasksStreamFamily._allTransitiveDependencies,
          uid: uid,
        );

  RemoteTasksStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<List<Task>> Function(RemoteTasksStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoteTasksStreamProvider._internal(
        (ref) => create(ref as RemoteTasksStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Task>> createElement() {
    return _RemoteTasksStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoteTasksStreamProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RemoteTasksStreamRef on AutoDisposeStreamProviderRef<List<Task>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _RemoteTasksStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Task>>
    with RemoteTasksStreamRef {
  _RemoteTasksStreamProviderElement(super.provider);

  @override
  String get uid => (origin as RemoteTasksStreamProvider).uid;
}

String _$remoteTaskStreamHash() => r'7f6bb6afa05eda30f11f64ff9612aa1ae352510a';

/// See also [remoteTaskStream].
@ProviderFor(remoteTaskStream)
const remoteTaskStreamProvider = RemoteTaskStreamFamily();

/// See also [remoteTaskStream].
class RemoteTaskStreamFamily extends Family<AsyncValue<Task?>> {
  /// See also [remoteTaskStream].
  const RemoteTaskStreamFamily();

  /// See also [remoteTaskStream].
  RemoteTaskStreamProvider call(
    String uid,
    String taskId,
  ) {
    return RemoteTaskStreamProvider(
      uid,
      taskId,
    );
  }

  @override
  RemoteTaskStreamProvider getProviderOverride(
    covariant RemoteTaskStreamProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'remoteTaskStreamProvider';
}

/// See also [remoteTaskStream].
class RemoteTaskStreamProvider extends AutoDisposeStreamProvider<Task?> {
  /// See also [remoteTaskStream].
  RemoteTaskStreamProvider(
    String uid,
    String taskId,
  ) : this._internal(
          (ref) => remoteTaskStream(
            ref as RemoteTaskStreamRef,
            uid,
            taskId,
          ),
          from: remoteTaskStreamProvider,
          name: r'remoteTaskStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$remoteTaskStreamHash,
          dependencies: RemoteTaskStreamFamily._dependencies,
          allTransitiveDependencies:
              RemoteTaskStreamFamily._allTransitiveDependencies,
          uid: uid,
          taskId: taskId,
        );

  RemoteTaskStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
    required this.taskId,
  }) : super.internal();

  final String uid;
  final String taskId;

  @override
  Override overrideWith(
    Stream<Task?> Function(RemoteTaskStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoteTaskStreamProvider._internal(
        (ref) => create(ref as RemoteTaskStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
        taskId: taskId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Task?> createElement() {
    return _RemoteTaskStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoteTaskStreamProvider &&
        other.uid == uid &&
        other.taskId == taskId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, taskId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RemoteTaskStreamRef on AutoDisposeStreamProviderRef<Task?> {
  /// The parameter `uid` of this provider.
  String get uid;

  /// The parameter `taskId` of this provider.
  String get taskId;
}

class _RemoteTaskStreamProviderElement
    extends AutoDisposeStreamProviderElement<Task?> with RemoteTaskStreamRef {
  _RemoteTaskStreamProviderElement(super.provider);

  @override
  String get uid => (origin as RemoteTaskStreamProvider).uid;
  @override
  String get taskId => (origin as RemoteTaskStreamProvider).taskId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
