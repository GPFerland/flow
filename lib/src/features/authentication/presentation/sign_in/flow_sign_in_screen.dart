import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flow/src/features/authentication/data/auth_repository.dart';
import 'package:flow/src/features/authentication/presentation/ui_auth_providers.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowSignInScreen extends ConsumerWidget {
  const FlowSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final authProviders = ref.watch(authProvidersProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'.hardcoded),
      ),
      body: SignInScreen(
        auth: authRepository,
        providers: authProviders,
      ),
    );
  }
}
