import 'package:flow/widgets/drawer/drawer_navigation_buttons/show_routines_screen_button.dart';
import 'package:flow/widgets/drawer/drawer_navigation_buttons/show_selected_date_list_screen_button.dart';
import 'package:flow/widgets/drawer/drawer_navigation_buttons/show_tasks_screen_button.dart';
import 'package:flutter/material.dart';

class DrawerNavigationButtons extends StatelessWidget {
  const DrawerNavigationButtons({super.key});

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
                ShowSelectedDateListScreenButton(),
                ShowTasksScreenButton(),
                ShowRoutinesScreenButton(),
              ],
            ));
      },
    );
  }
}
