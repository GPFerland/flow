import 'package:flow/providers/date/selected_date_provider.dart';
import 'package:flow/utils/style.dart';
import 'package:flow/widgets/app_bar/default_app_bar.dart';
import 'package:flow/screens/selected_date_list/widgets/floating_action_buttons/floating_action_buttons.dart';
import 'package:flow/widgets/drawer/default_drawer.dart';
import 'package:flow/screens/selected_date_list/widgets/lists/selected_date_list.dart';
import 'package:flow/screens/selected_date_list/widgets/selected_date_list_screen_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDateListScreen extends ConsumerWidget {
  const SelectedDateListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double deltaX = 0;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: const DefaultAppBar(
        title: SelectedDateListScreenTitle(),
      ),
      drawer: const DefaultDrawer(),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth >= 840 ? 840 : screenWidth,
          ),
          child: GestureDetector(
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
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SelectedDateList(),
                    Container(height: footerTileHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840),
        child: const FloatingActionButtons(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
