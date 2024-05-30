import 'package:flow/providers/date/selected_date_provider.dart';
import 'package:flow/widgets/app_bar/default_app_bar.dart';
import 'package:flow/widgets/buttons/hide_completed_items_button.dart';
import 'package:flow/widgets/buttons/navigation_floating_action_buttons.dart';
import 'package:flow/widgets/drawer/default_drawer.dart';
import 'package:flow/widgets/lists/selected_date_list.dart';
import 'package:flow/widgets/titles/list_screen_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double deltaX = 0;

    return Scaffold(
      appBar: const DefaultAppBar(
        title: ListScreenTitle(),
      ),
      drawer: const DefaultDrawer(),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          deltaX += details.delta.dx;
        },
        onHorizontalDragEnd: (details) {
          // Swiping in right direction.
          if (deltaX > 100) {
            ref.read(selectedDateProvider.notifier).selectPreviousDay();
          }
          // Swiping in left direction.
          if (deltaX < -100) {
            ref.read(selectedDateProvider.notifier).selectNextDay();
          }
          deltaX = 0;
        },
        child: ListView(
          children: const [
            SelectedDateList(),
            HideCompletedItemsButton(),
          ],
        ),
      ),
      floatingActionButton: const NavigationFloatingActionButtons(),
    );
  }
}
