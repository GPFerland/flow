import 'package:flow/data/providers/screen/screen_provider.dart';
import 'package:flow/features/routines_list/views/routines_screen.dart';
import 'package:flow/features/routines_list/widgets/reorderable_routine_list_title.dart';
import 'package:flow/features/selected_date_list/views/swipeable_list_screen.dart';
import 'package:flow/features/selected_date_list/widgets/selected_date_list_title.dart';
import 'package:flow/features/tasks_list/views/tasks_screen.dart';
import 'package:flow/features/tasks_list/widgets/reorderable_task_list_title.dart';
import 'package:flow/widgets/app_bar/default_app_bar.dart';
import 'package:flow/widgets/drawer/default_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
  });

  Widget _getScreen(AppScreen screen, AppScreenWidth width) {
    switch (screen) {
      case AppScreen.selectedDateList:
        return SwipeableListScreen(width: width);
      case AppScreen.tasksList:
        return const TasksScreen();
      case AppScreen.routinesList:
        return const RoutinesScreen();
    }
  }

  PreferredSizeWidget? _getAppBar(AppScreen screen) {
    switch (screen) {
      case AppScreen.selectedDateList:
        return const DefaultAppBar(
          title: SelectedDateListTitle(),
        );
      case AppScreen.tasksList:
        return const DefaultAppBar(
          title: ReorderableTaskListTitle(),
          showBackButton: true,
        );
      case AppScreen.routinesList:
        return const DefaultAppBar(
          title: ReorderableRoutineListTitle(),
          showBackButton: true,
        );
    }
  }

  Widget? _getDrawer(AppScreen screen) {
    switch (screen) {
      case AppScreen.selectedDateList:
        return const DefaultDrawer();
      case AppScreen.tasksList:
        return null;
      case AppScreen.routinesList:
        return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    final AppScreen currentScreen = ref.watch(screenProvider);
    final AppScreenWidth currentWidth =
        screenWidth < smallCutoff ? AppScreenWidth.small : AppScreenWidth.large;

    Widget? bodyContent;
    PreferredSizeWidget? appBar;
    Widget? drawer;

    if (currentWidth == AppScreenWidth.small) {
      appBar = _getAppBar(currentScreen);
      drawer = _getDrawer(currentScreen);
      bodyContent = _getScreen(currentScreen, currentWidth);
    } else {
      appBar = null;
      drawer = null;
      bodyContent = Row(
        children: [
          const DefaultDrawer(popContext: false),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 840),
                child: _getScreen(currentScreen, currentWidth),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: appBar,
      drawer: drawer,
      body: bodyContent,
    );
  }
}
