import 'package:flow/src/common_widgets/buttons/action_text_button.dart';
import 'package:flow/src/features/check_list/presentation/app_bar/check_list_app_bar_title.dart';
import 'package:flow/src/features/check_list/presentation/app_bar/compact_menu_buttons.dart';
import 'package:flow/src/constants/breakpoints.dart';
import 'package:flow/src/features/authentication/data/test_auth_repository.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CheckListAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CheckListAppBar({super.key});

  // * Keys for testing using find.byKey()
  static const tasksMenuButtonKey = Key('tasksMenuButton');
  static const accountMenuButtonKey = Key('accountMenuButton');
  static const signInMenuButtonKey = Key('signInMenuButton');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    // * This widget is responsive.
    // * On large screen sizes, it shows all the actions in the app bar.
    // * On small screen sizes, it shows only the [CompactMenuButtons].
    // ! MediaQuery is used on the assumption that the widget takes up the full
    // ! width of the screen. If that's not the case, LayoutBuilder should be
    // ! used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < Breakpoint.tablet) {
      return AppBar(
        title: const CheckListAppBarTitle(),
        actions: [
          CompactMenuButtons(user: user),
        ],
      );
    } else {
      return AppBar(
        title: const CheckListAppBarTitle(),
        actions: [
          ActionTextButton(
            key: tasksMenuButtonKey,
            text: 'Tasks'.hardcoded,
            onPressed: () => context.goNamed(AppRoute.tasks.name),
          ),
          if (user != null)
            ActionTextButton(
              key: accountMenuButtonKey,
              text: 'Account'.hardcoded,
              onPressed: () => context.goNamed(AppRoute.account.name),
            )
          else
            ActionTextButton(
              key: signInMenuButtonKey,
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
