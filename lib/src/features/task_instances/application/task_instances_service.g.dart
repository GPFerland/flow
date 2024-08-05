// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_instances_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskInstancesServiceHash() =>
    r'e75df420534d9ccf20bb1f361a03de77ef3acc25';

/// See also [taskInstancesService].
@ProviderFor(taskInstancesService)
final taskInstancesServiceProvider = Provider<TaskInstancesService>.internal(
  taskInstancesService,
  name: r'taskInstancesServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskInstancesServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TaskInstancesServiceRef = ProviderRef<TaskInstancesService>;
String _$dateTaskInstancesStreamHash() =>
    r'b621c54083d5b83da94b25feaa58f4425f6abb4a';

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

/// See also [dateTaskInstancesStream].
@ProviderFor(dateTaskInstancesStream)
const dateTaskInstancesStreamProvider = DateTaskInstancesStreamFamily();

/// See also [dateTaskInstancesStream].
class DateTaskInstancesStreamFamily
    extends Family<AsyncValue<List<TaskInstance>>> {
  /// See also [dateTaskInstancesStream].
  const DateTaskInstancesStreamFamily();

  /// See also [dateTaskInstancesStream].
  DateTaskInstancesStreamProvider call(
    DateTime date,
  ) {
    return DateTaskInstancesStreamProvider(
      date,
    );
  }

  @override
  DateTaskInstancesStreamProvider getProviderOverride(
    covariant DateTaskInstancesStreamProvider provider,
  ) {
    return call(
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
  String? get name => r'dateTaskInstancesStreamProvider';
}

/// See also [dateTaskInstancesStream].
class DateTaskInstancesStreamProvider
    extends AutoDisposeStreamProvider<List<TaskInstance>> {
  /// See also [dateTaskInstancesStream].
  DateTaskInstancesStreamProvider(
    DateTime date,
  ) : this._internal(
          (ref) => dateTaskInstancesStream(
            ref as DateTaskInstancesStreamRef,
            date,
          ),
          from: dateTaskInstancesStreamProvider,
          name: r'dateTaskInstancesStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dateTaskInstancesStreamHash,
          dependencies: DateTaskInstancesStreamFamily._dependencies,
          allTransitiveDependencies:
              DateTaskInstancesStreamFamily._allTransitiveDependencies,
          date: date,
        );

  DateTaskInstancesStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    Stream<List<TaskInstance>> Function(DateTaskInstancesStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DateTaskInstancesStreamProvider._internal(
        (ref) => create(ref as DateTaskInstancesStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TaskInstance>> createElement() {
    return _DateTaskInstancesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DateTaskInstancesStreamProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DateTaskInstancesStreamRef
    on AutoDisposeStreamProviderRef<List<TaskInstance>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _DateTaskInstancesStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<TaskInstance>>
    with DateTaskInstancesStreamRef {
  _DateTaskInstancesStreamProviderElement(super.provider);

  @override
  DateTime get date => (origin as DateTaskInstancesStreamProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
