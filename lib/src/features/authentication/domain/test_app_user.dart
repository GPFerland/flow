import 'package:flow/src/features/authentication/domain/app_user.dart';

/// Test user class used to simulate a user account on the backend
class TestAppUser extends AppUser {
  TestAppUser({
    required super.uid,
    required super.email,
    required this.password,
  });
  final String password;
}
