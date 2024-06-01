import 'package:flow/widgets/drawer/default_drawer_divider.dart';
import 'package:flow/widgets/drawer/drawer_navigation_buttons/drawer_navigation_buttons.dart';
import 'package:flow/widgets/drawer/drawer_theme_buttons/drawer_theme_buttons.dart';
import 'package:flow/widgets/drawer/default_drawer_header.dart';
import 'package:flow/widgets/drawer/drawer_account_buttons/drawer_account_buttons.dart';
import 'package:flutter/material.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            top: 60,
            bottom: 20,
          ),
          child: Column(
            children: [
              DefaultDrawerHeader(),
              DefaultDrawerDivider(),
              DrawerNavigationButtons(),
              DefaultDrawerDivider(),
              DrawerThemeButtons(),
              DefaultDrawerDivider(),
              DrawerAccountButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
