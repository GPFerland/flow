import 'package:flow/src/features/authentication/domain/app_user.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum PopupMenuOption {
  tasks,
  routines,
  account,
  signIn,
}

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({super.key, this.user});
  final AppUser? user;

  // * Keys for testing using find.byKey()
  static const tasksKey = Key('menuTasks');
  static const routinesKey = Key('menuRoutines');
  static const accountKey = Key('menuAccount');
  static const signInKey = Key('menuSignIn');

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // three vertical dots icon (to reveal menu options)
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        // show all the options based on conditional logic
        return user != null
            ? <PopupMenuEntry<PopupMenuOption>>[
                PopupMenuItem(
                  key: tasksKey,
                  value: PopupMenuOption.tasks,
                  child: Text('Tasks'.hardcoded),
                ),
                PopupMenuItem(
                  key: routinesKey,
                  value: PopupMenuOption.routines,
                  child: Text('Routines'.hardcoded),
                ),
                PopupMenuItem(
                  key: accountKey,
                  value: PopupMenuOption.account,
                  child: Text('Account'.hardcoded),
                ),
              ]
            : <PopupMenuEntry<PopupMenuOption>>[
                PopupMenuItem(
                  key: tasksKey,
                  value: PopupMenuOption.tasks,
                  child: Text('Tasks'.hardcoded),
                ),
                PopupMenuItem(
                  key: routinesKey,
                  value: PopupMenuOption.routines,
                  child: Text('Routines'.hardcoded),
                ),
                PopupMenuItem(
                  key: signInKey,
                  value: PopupMenuOption.signIn,
                  child: Text('Sign In'.hardcoded),
                ),
              ];
      },
      onSelected: (option) {
        // push to different routes based on selected option
        switch (option) {
          case PopupMenuOption.tasks:
            context.goNamed(AppRoute.tasks.name);
            break;
          case PopupMenuOption.routines:
            context.goNamed(AppRoute.routines.name);
            break;
          case PopupMenuOption.account:
            context.goNamed(AppRoute.account.name);
            break;
          case PopupMenuOption.signIn:
            context.goNamed(AppRoute.signIn.name);
            break;
        }
      },
    );
  }
}
