// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_task_instances_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$remoteTaskInstancesRepositoryHash() =>
    r'bc3ffb6975bed38af6f8db0b50b132f95d369411';

/// See also [remoteTaskInstancesRepository].
@ProviderFor(remoteTaskInstancesRepository)
final remoteTaskInstancesRepositoryProvider =
    Provider<RemoteTaskInstancesRepository>.internal(
  remoteTaskInstancesRepository,
  name: r'remoteTaskInstancesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remoteTaskInstancesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RemoteTaskInstancesRepositoryRef
    = ProviderRef<RemoteTaskInstancesRepository>;
String _$remoteTaskInstanceFutureHash() =>
    r'a64ed33448ca2655393dd331734a8d99f54c82e8';

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

/// See also [remoteTaskInstanceFuture].
@ProviderFor(remoteTaskInstanceFuture)
const remoteTaskInstanceFutureProvider = RemoteTaskInstanceFutureFamily();

/// See also [remoteTaskInstanceFuture].
class RemoteTaskInstanceFutureFamily extends Family<AsyncValue<TaskInstance?>> {
  /// See also [remoteTaskInstanceFuture].
  const RemoteTaskInstanceFutureFamily();

  /// See also [remoteTaskInstanceFuture].
  RemoteTaskInstanceFutureProvider call(
    String uid,
    String taskInstanceId,
  ) {
    return RemoteTaskInstanceFutureProvider(
      uid,
      taskInstanceId,
    );
  }

  @override
  RemoteTaskInstanceFutureProvider getProviderOverride(
    covariant RemoteTaskInstanceFutureProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'remoteTaskInstanceFutureProvider';
}

/// See also [remoteTaskInstanceFuture].
class RemoteTaskInstanceFutureProvider
    extends AutoDisposeFutureProvider<TaskInstance?> {
  /// See also [remoteTaskInstanceFuture].
  RemoteTaskInstanceFutureProvider(
    String uid,
    String taskInstanceId,
  ) : this._internal(
          (ref) => remoteTaskInstanceFuture(
            ref as RemoteTaskInstanceFutureRef,
            uid,
            taskInstanceId,
          ),
          from: remoteTaskInstanceFutureProvider,
          name: r'remoteTaskInstanceFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$remoteTaskInstanceFutureHash,
          dependencies: RemoteTaskInstanceFutureFamily._dependencies,
          allTransitiveDependencies:
              RemoteTaskInstanceFutureFamily._allTransitiveDependencies,
          uid: uid,
          taskInstanceId: taskInstanceId,
        );

  RemoteTaskInstanceFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
    required this.taskInstanceId,
  }) : super.internal();

  final String uid;
  final String taskInstanceId;

  @override
  Override overrideWith(
    FutureOr<TaskInstance?> Function(RemoteTaskInstanceFutureRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoteTaskInstanceFutureProvider._internal(
        (ref) => create(ref as RemoteTaskInstanceFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
        taskInstanceId: taskInstanceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TaskInstance?> createElement() {
    return _RemoteTaskInstanceFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoteTaskInstanceFutureProvider &&
        other.uid == uid &&
        other.taskInstanceId == taskInstanceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, taskInstanceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RemoteTaskInstanceFutureRef
    on AutoDisposeFutureProviderRef<TaskInstance?> {
  /// The parameter `uid` of this provider.
  String get uid;

  /// The parameter `taskInstanceId` of this provider.
  String get taskInstanceId;
}

class _RemoteTaskInstanceFutureProviderElement
    extends AutoDisposeFutureProviderElement<TaskInstance?>
    with RemoteTaskInstanceFutureRef {
  _RemoteTaskInstanceFutureProviderElement(super.provider);

  @override
  String get uid => (origin as RemoteTaskInstanceFutureProvider).uid;
  @override
  String get taskInstanceId =>
      (origin as RemoteTaskInstanceFutureProvider).taskInstanceId;
}

String _$remoteTaskInstancesFutureHash() =>
    r'4f009bf7e222096860c73a6669243cf8f5a3101c';

/// See also [remoteTaskInstancesFuture].
@ProviderFor(remoteTaskInstancesFuture)
const remoteTaskInstancesFutureProvider = RemoteTaskInstancesFutureFamily();

/// See also [remoteTaskInstancesFuture].
class RemoteTaskInstancesFutureFamily
    extends Family<AsyncValue<List<TaskInstance>>> {
  /// See also [remoteTaskInstancesFuture].
  const RemoteTaskInstancesFutureFamily();

  /// See also [remoteTaskInstancesFuture].
  RemoteTaskInstancesFutureProvider call(
    String uid,
  ) {
    return RemoteTaskInstancesFutureProvider(
      uid,
    );
  }

  @override
  RemoteTaskInstancesFutureProvider getProviderOverride(
    covariant RemoteTaskInstancesFutureProvider provider,
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
  String? get name => r'remoteTaskInstancesFutureProvider';
}

/// See also [remoteTaskInstancesFuture].
class RemoteTaskInstancesFutureProvider
    extends AutoDisposeFutureProvider<List<TaskInstance>> {
  /// See also [remoteTaskInstancesFuture].
  RemoteTaskInstancesFutureProvider(
    String uid,
  ) : this._internal(
          (ref) => remoteTaskInstancesFuture(
            ref as RemoteTaskInstancesFutureRef,
            uid,
          ),
          from: remoteTaskInstancesFutureProvider,
          name: r'remoteTaskInstancesFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$remoteTaskInstancesFutureHash,
          dependencies: RemoteTaskInstancesFutureFamily._dependencies,
          allTransitiveDependencies:
              RemoteTaskInstancesFutureFamily._allTransitiveDependencies,
          uid: uid,
        );

  RemoteTaskInstancesFutureProvider._internal(
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
    FutureOr<List<TaskInstance>> Function(RemoteTaskInstancesFutureRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoteTaskInstancesFutureProvider._internal(
        (ref) => create(ref as RemoteTaskInstancesFutureRef),
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
  AutoDisposeFutureProviderElement<List<TaskInstance>> createElement() {
    return _RemoteTaskInstancesFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoteTaskInstancesFutureProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RemoteTaskInstancesFutureRef
    on AutoDisposeFutureProviderRef<List<TaskInstance>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _RemoteTaskInstancesFutureProviderElement
    extends AutoDisposeFutureProviderElement<List<TaskInstance>>
    with RemoteTaskInstancesFutureRef {
  _RemoteTaskInstancesFutureProviderElement(super.provider);

  @override
  String get uid => (origin as RemoteTaskInstancesFutureProvider).uid;
}

String _$remoteTaskInstanceStreamHash() =>
    r'1b127c5f552ec41e5b34585a89cf0d5e234f697d';

/// See also [remoteTaskInstanceStream].
@ProviderFor(remoteTaskInstanceStream)
const remoteTaskInstanceStreamProvider = RemoteTaskInstanceStreamFamily();

/// See also [remoteTaskInstanceStream].
class RemoteTaskInstanceStreamFamily extends Family<AsyncValue<TaskInstance?>> {
  /// See also [remoteTaskInstanceStream].
  const RemoteTaskInstanceStreamFamily();

  /// See also [remoteTaskInstanceStream].
  RemoteTaskInstanceStreamProvider call(
    String uid,
    String taskInstanceId,
  ) {
    return RemoteTaskInstanceStreamProvider(
      uid,
      taskInstanceId,
    );
  }

  @override
  RemoteTaskInstanceStreamProvider getProviderOverride(
    covariant RemoteTaskInstanceStreamProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'remoteTaskInstanceStreamProvider';
}

/// See also [remoteTaskInstanceStream].
class RemoteTaskInstanceStreamProvider
    extends AutoDisposeStreamProvider<TaskInstance?> {
  /// See also [remoteTaskInstanceStream].
  RemoteTaskInstanceStreamProvider(
    String uid,
    String taskInstanceId,
  ) : this._internal(
          (ref) => remoteTaskInstanceStream(
            ref as RemoteTaskInstanceStreamRef,
            uid,
            taskInstanceId,
          ),
          from: remoteTaskInstanceStreamProvider,
          name: r'remoteTaskInstanceStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$remoteTaskInstanceStreamHash,
          dependencies: RemoteTaskInstanceStreamFamily._dependencies,
          allTransitiveDependencies:
              RemoteTaskInstanceStreamFamily._allTransitiveDependencies,
          uid: uid,
          taskInstanceId: taskInstanceId,
        );

  RemoteTaskInstanceStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
    required this.taskInstanceId,
  }) : super.internal();

  final String uid;
  final String taskInstanceId;

  @override
  Override overrideWith(
    Stream<TaskInstance?> Function(RemoteTaskInstanceStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoteTaskInstanceStreamProvider._internal(
        (ref) => create(ref as RemoteTaskInstanceStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
        taskInstanceId: taskInstanceId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<TaskInstance?> createElement() {
    return _RemoteTaskInstanceStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoteTaskInstanceStreamProvider &&
        other.uid == uid &&
        other.taskInstanceId == taskInstanceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, taskInstanceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RemoteTaskInstanceStreamRef
    on AutoDisposeStreamProviderRef<TaskInstance?> {
  /// The parameter `uid` of this provider.
  String get uid;

  /// The parameter `taskInstanceId` of this provider.
  String get taskInstanceId;
}

class _RemoteTaskInstanceStreamProviderElement
    extends AutoDisposeStreamProviderElement<TaskInstance?>
    with RemoteTaskInstanceStreamRef {
  _RemoteTaskInstanceStreamProviderElement(super.provider);

  @override
  String get uid => (origin as RemoteTaskInstanceStreamProvider).uid;
  @override
  String get taskInstanceId =>
      (origin as RemoteTaskInstanceStreamProvider).taskInstanceId;
}

String _$remoteTaskInstancesStreamHash() =>
    r'946ca518cba6b3567f234fad88d2b05efd1f831b';

/// See also [remoteTaskInstancesStream].
@ProviderFor(remoteTaskInstancesStream)
const remoteTaskInstancesStreamProvider = RemoteTaskInstancesStreamFamily();

/// See also [remoteTaskInstancesStream].
class RemoteTaskInstancesStreamFamily
    extends Family<AsyncValue<List<TaskInstance>>> {
  /// See also [remoteTaskInstancesStream].
  const RemoteTaskInstancesStreamFamily();

  /// See also [remoteTaskInstancesStream].
  RemoteTaskInstancesStreamProvider call(
    String uid,
    DateTime? date,
  ) {
    return RemoteTaskInstancesStreamProvider(
      uid,
      date,
    );
  }

  @override
  RemoteTaskInstancesStreamProvider getProviderOverride(
    covariant RemoteTaskInstancesStreamProvider provider,
  ) {
    return call(
      provider.uid,
      provider.date,
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
  String? get name => r'remoteTaskInstancesStreamProvider';
}

/// See also [remoteTaskInstancesStream].
class RemoteTaskInstancesStreamProvider
    extends AutoDisposeStreamProvider<List<TaskInstance>> {
  /// See also [remoteTaskInstancesStream].
  RemoteTaskInstancesStreamProvider(
    String uid,
    DateTime? date,
  ) : this._internal(
          (ref) => remoteTaskInstancesStream(
            ref as RemoteTaskInstancesStreamRef,
            uid,
            date,
          ),
          from: remoteTaskInstancesStreamProvider,
          name: r'remoteTaskInstancesStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$remoteTaskInstancesStreamHash,
          dependencies: RemoteTaskInstancesStreamFamily._dependencies,
          allTransitiveDependencies:
              RemoteTaskInstancesStreamFamily._allTransitiveDependencies,
          uid: uid,
          date: date,
        );

  RemoteTaskInstancesStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
    required this.date,
  }) : super.internal();

  final String uid;
  final DateTime? date;

  @override
  Override overrideWith(
    Stream<List<TaskInstance>> Function(RemoteTaskInstancesStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoteTaskInstancesStreamProvider._internal(
        (ref) => create(ref as RemoteTaskInstancesStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TaskInstance>> createElement() {
    return _RemoteTaskInstancesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoteTaskInstancesStreamProvider &&
        other.uid == uid &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RemoteTaskInstancesStreamRef
    on AutoDisposeStreamProviderRef<List<TaskInstance>> {
  /// The parameter `uid` of this provider.
  String get uid;

  /// The parameter `date` of this provider.
  DateTime? get date;
}

class _RemoteTaskInstancesStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<TaskInstance>>
    with RemoteTaskInstancesStreamRef {
  _RemoteTaskInstancesStreamProviderElement(super.provider);

  @override
  String get uid => (origin as RemoteTaskInstancesStreamProvider).uid;
  @override
  DateTime? get date => (origin as RemoteTaskInstancesStreamProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
