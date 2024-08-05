import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flow/src/features/authentication/data/auth_repository.dart';
import 'package:flow/src/features/authentication/presentation/ui_auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowAccountScreen extends ConsumerWidget {
  const FlowAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final authProviders = ref.watch(authProvidersProvider);
    return ProfileScreen(
      auth: authRepository,
      appBar: AppBar(
        title: const Text('Account'),
      ),
      providers: authProviders,
    );
  }
}
