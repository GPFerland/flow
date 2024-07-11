import 'package:flow/src/exceptions/app_exception.dart';
import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flow/src/features/authentication/domain/test_app_user.dart';
import 'package:flow/src/utils/delay.dart';
import 'package:flow/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestAuthRepository {
  TestAuthRepository({this.addDelay = true});

  final bool addDelay;

  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;

  AppUser? get currentUser => _authState.value;

  // List to keep track of all user accounts
  final List<TestAppUser> _users = [];

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // add a delay to simulate loading
    await delay(addDelay);
    // check the given credentials against each registered user
    for (final user in _users) {
      // matching email and password
      if (user.email == email && user.password == password) {
        _authState.value = user;
        return;
      }
      // same email, wrong password
      if (user.email == email && user.password != password) {
        throw WrongPasswordException();
      }
    }
    throw UserNotFoundException();
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // add a delay to simulate loading
    await delay(addDelay);
    // check if the email is already in use
    for (final u in _users) {
      if (u.email == email) {
        throw EmailAlreadyInUseException();
      }
    }
    // minimum password length requirement
    if (password.length < 8) {
      throw WeakPasswordException();
    }
    // create new user
    _createNewUser(email, password);
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email, String password) {
    // create new user
    final user = TestAppUser(
      uid: email.split('').reversed.join(),
      email: email,
      password: password,
    );
    // register it
    _users.add(user);
    // update the auth state
    _authState.value = user;
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
