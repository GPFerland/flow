import 'package:flow/src/common_widgets/buttons/add_icon_button.dart';
import 'package:flow/src/common_widgets/buttons/back_icon_button.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  final Widget title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      leading: showBackButton ? const BackIconButton() : null,
      title: Center(child: title),
      backgroundColor: theme.colorScheme.primary,
      iconTheme: theme.iconTheme.copyWith(color: theme.colorScheme.onPrimary),
      actions: const [AddIconButton()],
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
