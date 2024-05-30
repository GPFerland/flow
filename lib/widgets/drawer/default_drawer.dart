import 'package:flow/widgets/buttons/show_routines_screen_button.dart';
import 'package:flow/widgets/buttons/show_tasks_screen_button.dart';
import 'package:flow/widgets/dividers/divider_on_secondary_container.dart';
import 'package:flow/widgets/footers/drawer_footer_tile.dart';
import 'package:flow/widgets/headers/title_drawer_header.dart';
import 'package:flow/widgets/input_fields/color/color_input_list_tile.dart';
import 'package:flow/widgets/input_fields/toggle/dark_mode_toggle_slider.dart';
import 'package:flutter/material.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DefaultDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: const [
                ShowTasksScreenButton(),
                DividerOnSecondaryContainer(),
                ShowRoutinesScreenButton(),
                DividerOnSecondaryContainer(),
                ThemeColorListTile(),
                DividerOnSecondaryContainer(),
                DarkModeToggleSlider(),
                DividerOnSecondaryContainer(),
                // ShowTasksScreenButton(),
                // DividerOnSecondaryContainer(),
                // ShowRoutinesScreenButton(),
                // DividerOnSecondaryContainer(),
                // ThemeColorListTile(),
                // DividerOnSecondaryContainer(),
                // DarkModeToggleSlider(),
                // DividerOnSecondaryContainer(),
                // ShowTasksScreenButton(),
                // DividerOnSecondaryContainer(),
                // ShowRoutinesScreenButton(),
                // DividerOnSecondaryContainer(),
                // ThemeColorListTile(),
                // DividerOnSecondaryContainer(),
                // DarkModeToggleSlider(),
                // DividerOnSecondaryContainer(),
                // ShowTasksScreenButton(),
                // DividerOnSecondaryContainer(),
                // ShowRoutinesScreenButton(),
                // DividerOnSecondaryContainer(),
                // ThemeColorListTile(),
                // DividerOnSecondaryContainer(),
                // DarkModeToggleSlider(),
                // DividerOnSecondaryContainer(),
              ],
            ),
          ),
          const DividerOnSecondaryContainer(),
          const DrawerFooterTile(),
        ],
      ),
    );
  }
}
