import 'package:flow/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flow/src/features/authentication/presentation/account/account_screen.dart';
import 'package:flow/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:flow/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flow/src/features/check_list/presentation/check_list.dart';
import 'package:flow/src/features/routines/presentation/routines_screen.dart';
import 'package:flow/src/features/tasks/presentation/tasks_screen.dart';
import 'package:flow/src/routing/go_router_refresh_stream.dart';
import 'package:flow/src/routing/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  checkList,
  tasks,
  task,
  routines,
  routine,
  account,
  signIn,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.uri.path;
      if (isLoggedIn) {
        if (path == '/signIn') {
          return '/';
        }
      } else {
        if (path == '/account' || path == '/orders') {
          return '/';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.checkList.name,
        builder: (context, state) => const CheckListScreen(),
        routes: [
          GoRoute(
            path: 'tasks',
            name: AppRoute.tasks.name,
            builder: (context, state) => const TasksScreen(),
            routes: [
              GoRoute(
                path: 'task/:id',
                name: AppRoute.task.name,
                pageBuilder: (context, state) {
                  final taskId = state.pathParameters['id']!;
                  return const MaterialPage(
                    fullscreenDialog: true,
                    child: Placeholder(),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'routines',
            name: AppRoute.routines.name,
            builder: (context, state) => const RoutinesScreen(),
            routes: [
              GoRoute(
                path: 'routine/:id',
                name: AppRoute.routine.name,
                pageBuilder: (context, state) {
                  final routineId = state.pathParameters['id']!;
                  return const MaterialPage(
                    fullscreenDialog: true,
                    child: Placeholder(),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: AccountScreen(),
            ),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.signIn,
              ),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
