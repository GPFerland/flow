import 'package:flow/src/features/authentication/data/auth_repository.dart';
import 'package:flow/src/features/authentication/presentation/account/flow_account_screen.dart';
import 'package:flow/src/features/authentication/presentation/sign_in/flow_sign_in_screen.dart';
import 'package:flow/src/features/check_list/presentation/check_list_screen.dart';
import 'package:flow/src/features/tasks/presentation/task/task_screen.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list/tasks_list_screen.dart';
import 'package:flow/src/routing/go_router_refresh_stream.dart';
import 'package:flow/src/routing/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum AppRoute {
  checkList,
  tasks,
  editTask,
  createTask,
  account,
  signIn,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.uri.path == '/${AppRoute.signIn.name}') {
          return '/';
        }
      } else {
        if (state.uri.path == '/${AppRoute.account.name}') {
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
            builder: (context, state) => const TasksListScreen(),
            routes: [
              GoRoute(
                path: 'task/:id',
                name: AppRoute.editTask.name,
                pageBuilder: (context, state) {
                  final taskId = state.pathParameters['id']!;
                  return MaterialPage(
                    fullscreenDialog: true,
                    child: TaskScreen(taskId: taskId),
                  );
                },
              ),
              GoRoute(
                path: 'createTask',
                name: AppRoute.createTask.name,
                pageBuilder: (context, state) {
                  return const MaterialPage(
                    fullscreenDialog: true,
                    child: TaskScreen(),
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
              child: FlowAccountScreen(),
            ),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: FlowSignInScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
