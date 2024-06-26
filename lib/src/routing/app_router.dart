import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/features/authentication/presentation/account/account_screen.dart';
import 'package:flow/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:flow/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flow/src/features/date_check_list/presentation/date_check_list_screen.dart';
import 'package:flow/src/features/tasks/presentation/create_task_screen/create_task_screen.dart';
import 'package:flow/src/features/tasks/presentation/edit_task_screen/edit_task_screen.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list_screen/tasks_list_screen.dart';
import 'package:flow/src/routing/go_router_refresh_stream.dart';
import 'package:flow/src/routing/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  checkList,
  tasks,
  editTask,
  createTask,
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
        if (path == '/${AppRoute.signIn.name}') {
          return '/';
        }
      } else {
        if (path == '/${AppRoute.account.name}') {
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
        builder: (context, state) => const DateCheckListScreen(),
        routes: [
          GoRoute(
            path: 'tasks',
            name: AppRoute.tasks.name,
            builder: (context, state) => const TasksListScreen(),
            routes: [
              GoRoute(
                path: 'task/:id',
                name: AppRoute.editTask.name,
                pageBuilder: (context, state) {
                  final taskId = state.pathParameters['id']!;
                  return MaterialPage(
                    fullscreenDialog: true,
                    child: EditTaskScreen(taskId: taskId),
                  );
                },
              ),
              GoRoute(
                path: 'createTask',
                name: AppRoute.createTask.name,
                pageBuilder: (context, state) {
                  return const MaterialPage(
                    fullscreenDialog: true,
                    child: CreateTaskScreen(),
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
