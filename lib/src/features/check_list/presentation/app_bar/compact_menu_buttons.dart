import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/src/features/check_list/presentation/app_bar/check_list_app_bar.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum PopupMenuOption {
  tasks,
  account,
  signIn,
}

class CompactMenuButtons extends StatelessWidget {
  const CompactMenuButtons({
    super.key,
    this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // three vertical dots icon (to reveal menu options)
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        // show all the options based on conditional logic
        return <PopupMenuEntry<PopupMenuOption>>[
          PopupMenuItem(
            key: CheckListAppBar.tasksMenuButtonKey,
            value: PopupMenuOption.tasks,
            child: Text('Tasks'.hardcoded),
          ),
          if (user != null)
            PopupMenuItem(
              key: CheckListAppBar.accountMenuButtonKey,
              value: PopupMenuOption.account,
              child: Text('Account'.hardcoded),
            )
          else
            PopupMenuItem(
              key: CheckListAppBar.signInMenuButtonKey,
              value: PopupMenuOption.signIn,
              child: Text('Sign In'.hardcoded),
            )
        ];
      },
      onSelected: (option) {
        // push to different routes based on selected option
        switch (option) {
          case PopupMenuOption.tasks:
            context.goNamed(AppRoute.tasks.name);
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
