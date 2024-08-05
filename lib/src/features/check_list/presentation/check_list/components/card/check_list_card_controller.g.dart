// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_list_card_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkListCardControllerHash() =>
    r'e114595942c6e01288a6ae912890aa678f389399';

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

abstract class _$CheckListCardController
    extends BuildlessAutoDisposeAsyncNotifier<void> {
  late final TaskInstance taskInstance;

  FutureOr<void> build(
    TaskInstance taskInstance,
  );
}

/// See also [CheckListCardController].
@ProviderFor(CheckListCardController)
const checkListCardControllerProvider = CheckListCardControllerFamily();

/// See also [CheckListCardController].
class CheckListCardControllerFamily extends Family<AsyncValue<void>> {
  /// See also [CheckListCardController].
  const CheckListCardControllerFamily();

  /// See also [CheckListCardController].
  CheckListCardControllerProvider call(
    TaskInstance taskInstance,
  ) {
    return CheckListCardControllerProvider(
      taskInstance,
    );
  }

  @override
  CheckListCardControllerProvider getProviderOverride(
    covariant CheckListCardControllerProvider provider,
  ) {
    return call(
      provider.taskInstance,
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
  String? get name => r'checkListCardControllerProvider';
}

/// See also [CheckListCardController].
class CheckListCardControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<CheckListCardController,
        void> {
  /// See also [CheckListCardController].
  CheckListCardControllerProvider(
    TaskInstance taskInstance,
  ) : this._internal(
          () => CheckListCardController()..taskInstance = taskInstance,
          from: checkListCardControllerProvider,
          name: r'checkListCardControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$checkListCardControllerHash,
          dependencies: CheckListCardControllerFamily._dependencies,
          allTransitiveDependencies:
              CheckListCardControllerFamily._allTransitiveDependencies,
          taskInstance: taskInstance,
        );

  CheckListCardControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.taskInstance,
  }) : super.internal();

  final TaskInstance taskInstance;

  @override
  FutureOr<void> runNotifierBuild(
    covariant CheckListCardController notifier,
  ) {
    return notifier.build(
      taskInstance,
    );
  }

  @override
  Override overrideWith(CheckListCardController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CheckListCardControllerProvider._internal(
        () => create()..taskInstance = taskInstance,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        taskInstance: taskInstance,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CheckListCardController, void>
      createElement() {
    return _CheckListCardControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CheckListCardControllerProvider &&
        other.taskInstance == taskInstance;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, taskInstance.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CheckListCardControllerRef on AutoDisposeAsyncNotifierProviderRef<void> {
  /// The parameter `taskInstance` of this provider.
  TaskInstance get taskInstance;
}

class _CheckListCardControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CheckListCardController,
        void> with CheckListCardControllerRef {
  _CheckListCardControllerProviderElement(super.provider);

  @override
  TaskInstance get taskInstance =>
      (origin as CheckListCardControllerProvider).taskInstance;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
