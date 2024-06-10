import 'package:flow/src/common_widgets/drawer/drawer_account_buttons/drawer_about_us_button.dart';
import 'package:flutter/material.dart';

class DrawerAccountButtons extends StatelessWidget {
  const DrawerAccountButtons({super.key});

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
                SizedBox(height: 8),
                DrawerAboutUsButton(),
              ],
            ));
      },
    );
  }
}