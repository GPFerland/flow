import 'package:flow/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckListScreenController extends StateNotifier<AsyncValue> {
  CheckListScreenController({required this.authRepository})
      : super(const AsyncValue.data(null));
  final FakeAuthRepository authRepository;
}

final checkListScreenControllerProvider =
    StateNotifierProvider.autoDispose<CheckListScreenController, AsyncValue>(
        (ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return CheckListScreenController(
    authRepository: authRepository,
  );
});
