import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_auth_providers.g.dart';

@riverpod
List<AuthProvider> authProviders(AuthProvidersRef ref) {
  return [EmailAuthProvider()];
}
