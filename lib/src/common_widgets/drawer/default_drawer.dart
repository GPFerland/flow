import 'package:flow/src/common_widgets/drawer/default_drawer_divider.dart';
import 'package:flow/src/common_widgets/drawer/drawer_navigation_buttons/drawer_navigation_buttons.dart';
import 'package:flow/src/common_widgets/drawer/drawer_theme_buttons/drawer_theme_buttons.dart';
import 'package:flow/src/common_widgets/drawer/default_drawer_header.dart';
import 'package:flow/src/common_widgets/drawer/drawer_account_buttons/drawer_account_buttons.dart';
import 'package:flutter/material.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({
    super.key,
    this.popContext = true,
  });

  final bool popContext;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const LinearBorder(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 60,
            bottom: 20,
          ),
          child: Column(
            children: [
              const DefaultDrawerHeader(),
              const DefaultDrawerDivider(),
              DrawerNavigationButtons(popContext: popContext),
              const DefaultDrawerDivider(),
              const DrawerThemeButtons(),
              const DefaultDrawerDivider(),
              const DrawerAccountButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
