import 'package:flow/src/common_widgets/FUCK/providers/screen/screen_provider.dart';
import 'package:flow/src/common_widgets/drawer/drawer_navigation_buttons/show_screen_button.dart';
import 'package:flutter/material.dart';

class DrawerNavigationButtons extends StatelessWidget {
  const DrawerNavigationButtons({
    super.key,
    this.popContext = true,
  });

  final bool popContext;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final drawerWidth = constraints.maxWidth;
        final buttonsWidth = drawerWidth * 0.8;

        return SizedBox(
            width: buttonsWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShowScreenButton(
                  screen: AppScreen.checkList,
                  buttonTitle: 'List',
                  popContext: popContext,
                ),
                const SizedBox(height: 8),
                ShowScreenButton(
                  screen: AppScreen.tasksList,
                  buttonTitle: 'Tasks',
                  popContext: popContext,
                ),
                const SizedBox(height: 8),
                ShowScreenButton(
                  screen: AppScreen.routinesList,
                  buttonTitle: 'Routines',
                  popContext: popContext,
                ),
              ],
            ));
      },
    );
  }
}
