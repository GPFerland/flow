import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestAuthRepository {
  TestAuthRepository({this.addDelay = true});
  final bool addDelay;

  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  Future<void> signOut() async {
    await delay(addDelay);
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    _authState.value = AppUser(
      uid: email.split('').reversed.join(),
      email: email,
    );
  }
}

final authRepositoryProvider = Provider<TestAuthRepository>((ref) {
  final authRepository = TestAuthRepository();
  ref.onDispose(() => authRepository.dispose());
  return authRepository;
});

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
