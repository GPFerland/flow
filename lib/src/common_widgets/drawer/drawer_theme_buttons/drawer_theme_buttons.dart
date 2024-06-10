import 'package:flow/src/common_widgets/drawer/drawer_theme_buttons/toggle_dark_mode_button.dart';
import 'package:flow/src/common_widgets/drawer/drawer_theme_buttons/select_primary_color_button.dart';
import 'package:flutter/material.dart';

class DrawerThemeButtons extends StatelessWidget {
  const DrawerThemeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final drawerWidth = constraints.maxWidth;
        final buttonsWidth = drawerWidth * 0.8;

        return SizedBox(
          width: buttonsWidth,
          child: const Column(
            children: [
              SelectPrimaryColorButton(),
              SizedBox(height: 8),
              ToggleDarkModeButton(),
            ],
          ),
        );
      },
    );
  }
}
