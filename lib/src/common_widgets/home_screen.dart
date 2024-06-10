// import 'package:flow/src/common_widgets/FUCK/providers/future/task_and_routine_future_provider.dart';
// import 'package:flow/src/common_widgets/FUCK/providers/screen/screen_provider.dart';
// import 'package:flow/src/features/routines/presentation/routines_screen.dart';
// import 'package:flow/src/features/routines/presentation/reorderable_routine_list_title.dart';
// import 'package:flow/src/features/check_list/presentation/check_list_screen.dart';
// import 'package:flow/src/features/check_list/presentation/shimmer_loading_list.dart';
// import 'package:flow/src/features/check_list/presentation/selected_date_list_title.dart';
// import 'package:flow/src/features/tasks/presentation/tasks_screen.dart';
// import 'package:flow/src/features/tasks/presentation/reorderable_task_list_title.dart';
// import 'package:flow/src/common_widgets/app_bar/default_app_bar.dart';
// import 'package:flow/src/common_widgets/drawer/default_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({
//     super.key,
//   });

//   Widget _getScreen(AppScreen screen, AppScreenWidth width) {
//     switch (screen) {
//       case AppScreen.checkList:
//         return CheckListScreen(width: width);
//       case AppScreen.tasksList:
//         return const TasksScreen();
//       case AppScreen.routinesList:
//         return const RoutinesScreen();
//     }
//   }

//   PreferredSizeWidget? _getAppBar(AppScreen screen) {
//     switch (screen) {
//       case AppScreen.checkList:
//         return const DefaultAppBar(
//           title: CheckListTitle(),
//         );
//       case AppScreen.tasksList:
//         return const DefaultAppBar(
//           title: ReorderableTaskListTitle(),
//           showBackButton: true,
//         );
//       case AppScreen.routinesList:
//         return const DefaultAppBar(
//           title: ReorderableRoutineListTitle(),
//           showBackButton: true,
//         );
//     }
//   }

//   Widget? _getDrawer(AppScreen screen) {
//     switch (screen) {
//       case AppScreen.checkList:
//         return const DefaultDrawer();
//       case AppScreen.tasksList:
//         return null;
//       case AppScreen.routinesList:
//         return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     final AppScreen currentScreen = ref.watch(screenProvider);
//     final AppScreenWidth currentWidth =
//         screenWidth < smallCutoff ? AppScreenWidth.small : AppScreenWidth.large;

//     Widget? bodyContent;
//     PreferredSizeWidget? appBar;
//     Widget? drawer;

//     if (currentWidth == AppScreenWidth.small) {
//       appBar = _getAppBar(currentScreen);
//       drawer = _getDrawer(currentScreen);
//       bodyContent = _getScreen(currentScreen, currentWidth);
//     } else {
//       appBar = null;
//       drawer = null;
//       bodyContent = Row(
//         children: [
//           const DefaultDrawer(popContext: false),
//           Expanded(
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 840),
//                 child: _getScreen(currentScreen, currentWidth),
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       appBar: appBar,
//       drawer: drawer,
//       body: ref.watch(taskAndRoutineFutureProvider).when(
//         loading: () {
//           return const SizedBox(
//             height: double.infinity,
//             width: double.infinity,
//             child: SingleChildScrollView(
//               physics: AlwaysScrollableScrollPhysics(),
//               child: ShimmerLoadingList(),
//             ),
//           );
//         },
//         data: (data) {
//           return bodyContent;
//         },
//         error: (Object error, StackTrace stackTrace) {
//           return Center(
//             child: Text(error.toString()),
//           );
//         },
//       ),
//     );
//   }
// }
