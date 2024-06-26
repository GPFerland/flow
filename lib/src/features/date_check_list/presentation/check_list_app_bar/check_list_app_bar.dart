import 'package:flow/src/common_widgets/buttons/action_text_button.dart';
import 'package:flow/src/features/date_check_list/presentation/check_list_app_bar/date_check_list_title.dart';
import 'package:flow/src/features/date_check_list/presentation/check_list_app_bar/more_menu_button.dart';
import 'package:flow/src/constants/breakpoints.dart';
import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Custom [AppBar] widget that is reused by the [CheckListScreen] and
/// [TaskScreen].
/// It shows the following actions, depending on the application state:
/// - Tasks button
/// - Routines button
/// - Account or Sign-in button
class CheckListAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CheckListAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    // * This widget is responsive.
    // * On large screen sizes, it shows all the actions in the app bar.
    // * On small screen sizes, it shows only the shopping cart icon and a
    // * [MoreMenuButton].
    // ! MediaQuery is used on the assumption that the widget takes up the full
    // ! width of the screen. If that's not the case, LayoutBuilder should be
    // ! used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < Breakpoint.tablet) {
      return AppBar(
        title: const DateCheckListTitle(),
        actions: [
          MoreMenuButton(user: user),
        ],
      );
    } else {
      return AppBar(
        title: const DateCheckListTitle(),
        actions: [
          ActionTextButton(
            key: MoreMenuButton.tasksKey,
            text: 'Tasks'.hardcoded,
            onPressed: () => context.goNamed(AppRoute.tasks.name),
          ),
          if (user != null) ...[
            ActionTextButton(
              key: MoreMenuButton.accountKey,
              text: 'Account'.hardcoded,
              onPressed: () => context.goNamed(AppRoute.account.name),
            ),
          ] else
            ActionTextButton(
              key: MoreMenuButton.signInKey,
              text: 'Sign In'.hardcoded,
              onPressed: () => context.goNamed(AppRoute.signIn.name),
            )
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
