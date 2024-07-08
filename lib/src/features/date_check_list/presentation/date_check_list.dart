// import 'package:collection/collection.dart';
// import 'package:flow/src/features/routine_instances/domain/routine_instance.dart';
// import 'package:flow/src/features/tasks/domain/task.dart';
// import 'package:flow/src/features/task_instances/domain/task_instance.dart';
// import 'package:flow/src/common_widgets/FUCK/providers/models/routine_instances_provider.dart';
// import 'package:flow/src/common_widgets/FUCK/providers/models/task_instances_provider.dart';
// import 'package:flow/src/common_widgets/FUCK/providers/models/tasks_provider.dart';
// import 'package:flow/src/common_widgets/FUCK/providers/theme/show_completed_provider.dart';
// import 'package:flow/src/features/check_list/presentation/checkable_task_list_card.dart';
// import 'package:flow/src/features/check_list/presentation/expandable_routine_list_card.dart';
// import 'package:flow/src/features/check_list/presentation/floating_action_buttons/show_completed_items_button.dart';
// import 'package:flow/src/utils/date.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CheckList extends ConsumerStatefulWidget {
//   const CheckList({
//     super.key,
//   });

//   @override
//   ConsumerState<CheckList> createState() {
//     return _CheckListState();
//   }
// }

// class _CheckListState extends ConsumerState<CheckList>
//     with SingleTickerProviderStateMixin {
//   late List<dynamic>? _items;
//   final GlobalKey<AnimatedListState> _itemListKey =
//       GlobalKey<AnimatedListState>();
//   late AnimationController _animationController;
//   final Duration _animationDuration = const Duration(milliseconds: 250);
//   int? currentCombinedProviderHash;

//   DateTime date = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     _items = _getCheckList();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: _animationDuration,
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   List<dynamic> _getCheckList() {
//     final List<Task> tasks = ref.read(tasksProvider);
//     final bool showCompleted = ref.read(showCompletedProvider);
//     final routineInstanceList = ref.read(routineInstancesProvider);

//     final List<TaskInstance> taskInstances = [];
//     final List<RoutineInstance> routineInstances = [];
//     for (Task task in tasks) {
//       if (!task.isScheduled(date) && date == getDateNoTimeToday()) {
//         DateTime? previousDate = task.getPreviousScheduledDate(date);
//         TaskInstance? previousTaskInstance =
//             ref.read(taskInstancesProvider.notifier).getTaskInstance(
//                   task.id!,
//                   previousDate,
//                 );
//         if (previousTaskInstance == null) {
//           continue;
//         }

//         if (previousTaskInstance.rescheduledDate == date ||
//             (!previousTaskInstance.completed && task.untilCompleted!)) {
//           taskInstances.add(previousTaskInstance);
//           _addRoutineInstance(previousTaskInstance, routineInstances, ref);
//         }
//         continue;
//       }

//       TaskInstance? taskInstance = ref
//           .read(taskInstancesProvider.notifier)
//           .getTaskInstance(task.id!, date);

//       if (taskInstance == null) {
//         continue;
//       }

//       taskInstances.add(taskInstance);
//       _addRoutineInstance(taskInstance, routineInstances, ref);
//     }

//     final List<TaskInstance> uncompletedTaskInstances = [];
//     final List<TaskInstance> completedTaskInstances = [];
//     final List<TaskInstance> skippedTaskInstances = [];
//     for (TaskInstance taskInstance in taskInstances) {
//       if (taskInstance.completed) {
//         completedTaskInstances.add(taskInstance);
//       } else {
//         uncompletedTaskInstances.add(taskInstance);
//       }
//     }

//     final List<RoutineInstance> uncompletedRoutineInstances = [];
//     final List<RoutineInstance> completedRoutineInstances = [];
//     for (RoutineInstance routineInstance in routineInstances) {
//       completedRoutineInstances.add(routineInstance);
//       for (TaskInstance taskInstance in uncompletedTaskInstances) {
//         if (taskInstance.routineId == routineInstance.routineId) {
//           completedRoutineInstances.remove(routineInstance);
//           uncompletedRoutineInstances.add(routineInstance);
//           break;
//         }
//       }
//     }

//     List<dynamic> selectedDateCompletedList = _combineAndSortTasksAndRoutines(
//       date,
//       completedRoutineInstances,
//       completedTaskInstances,
//       true,
//     );

//     List<dynamic> selectedDateUncompletedList = _combineAndSortTasksAndRoutines(
//       date,
//       uncompletedRoutineInstances,
//       uncompletedTaskInstances,
//       false,
//     );

//     List<dynamic> selectedDateList = [];
//     if (showCompleted) {
//       selectedDateList = [
//         ...selectedDateUncompletedList,
//         ...selectedDateCompletedList,
//       ];
//     } else {
//       selectedDateList = [
//         ...selectedDateUncompletedList,
//       ];
//     }

//     return selectedDateList;
//   }

//   //todo - I fucking hate the name of this function
//   void _addRoutineInstance(
//     TaskInstance taskInstance,
//     List<RoutineInstance> selectedDateRoutineInstances,
//     WidgetRef ref,
//   ) {
//     if (taskInstance.routineId == null) {
//       return;
//     }

//     RoutineInstance? matchingRoutineInstance =
//         selectedDateRoutineInstances.firstWhereOrNull(
//       (element) {
//         return element.routineId == taskInstance.routineId;
//       },
//     );

//     if (matchingRoutineInstance == null) {
//       RoutineInstance? newRoutineInstance = ref
//           .read(routineInstancesProvider.notifier)
//           .getRoutineInstance(taskInstance.routineId!, date);
//       if (newRoutineInstance == null) {
//         return;
//       }
//       selectedDateRoutineInstances.add(newRoutineInstance);
//     }
//   }

//   List<dynamic> _combineAndSortTasksAndRoutines(
//     DateTime selectedDate,
//     List<RoutineInstance> routineInstances,
//     List<TaskInstance> taskInstances,
//     bool complete,
//   ) {
//     taskInstances = taskInstances
//         .where(
//           (element) => element.routineId == null,
//         )
//         .toList();

//     List<dynamic> combinedList = [...routineInstances, ...taskInstances];

//     combinedList.sort(
//       (a, b) {
//         if (a is RoutineInstance && b is RoutineInstance) {
//           if (complete) {
//             return a.getHighestTaskPriority().compareTo(
//                   b.getHighestTaskPriority(),
//                 );
//           } else {
//             return a.getHighestUncompletedTaskPriority().compareTo(
//                   b.getHighestUncompletedTaskPriority(),
//                 );
//           }
//         } else if (a is TaskInstance && b is TaskInstance) {
//           return a.taskPriority.compareTo(b.taskPriority);
//         } else if (a is RoutineInstance && b is TaskInstance) {
//           if (complete) {
//             return a.getHighestTaskPriority().compareTo(b.taskPriority);
//           } else {
//             return a
//                 .getHighestUncompletedTaskPriority()
//                 .compareTo(b.taskPriority);
//           }
//         } else {
//           if (complete) {
//             return a.taskPriority!.compareTo(
//               b.getHighestTaskPriority(selectedDate),
//             );
//           } else {
//             return a.taskPriority!.compareTo(
//               b.getHighestUncompletedTaskPriority(selectedDate),
//             );
//           }
//         }
//       },
//     );

//     final List<dynamic> expandedList = [];
//     for (var item in combinedList) {
//       expandedList.add(item);
//       if (item is RoutineInstance && item.isExpanded == true) {
//         expandedList.addAll(
//           item.taskInstances!
//             ..sort((a, b) => (a.completed ? 1 : 0) - (b.completed ? 1 : 0)),
//         );
//       }
//     }

//     return expandedList;
//   }

//   void _updateSelectedDateList() {
//     List<dynamic> newTodaysList = _getCheckList();

//     if (_items == null) {
//       _items = newTodaysList;
//       return;
//     }

//     // bool identical = true;
//     // if (_items!.length != newTodaysList.length) {
//     //   identical = false;
//     //   return;
//     // }
//     // for (int i = 0; i < _items!.length; i++) {
//     //   if (_items![i].id != newTodaysList[i].id) {
//     //     identical = false;
//     //     break;
//     //   }
//     //   if (_items![i] is RoutineInstance &&
//     //       newTodaysList[i] is RoutineInstance) {
//     //     final itemsTaskInstances = _items![i].taskInstances;
//     //     final newTaskInstances = newTodaysList[i].taskInstances;
//     //     if (itemsTaskInstances.length != newTaskInstances.length) {
//     //       identical = false;
//     //       break;
//     //     }
//     //     for (int j = 0; j < itemsTaskInstances.length; j++) {
//     //       if (itemsTaskInstances[j].id != newTaskInstances[j].id) {
//     //         identical = false;
//     //         break;
//     //       }
//     //     }
//     //   }
//     // }
//     // if (identical) {
//     //   return;
//     // }

//     final deepEq = const DeepCollectionEquality().equals;
//     if (deepEq(_items, newTodaysList)) {
//       return;
//     }

//     List<dynamic> itemsToShow = [];
//     List<dynamic> itemsToHide = [];
//     List<dynamic> itemsToMove = [];

//     for (var newItem in newTodaysList) {
//       if (!_items!.contains(newItem)) {
//         itemsToShow.add(newItem);
//       }
//     }

//     for (var oldItem in _items!) {
//       final newIndex = newTodaysList.indexOf(oldItem);
//       final oldIndex = _items!.indexOf(oldItem);
//       if (newIndex == -1 && oldIndex != -1) {
//         itemsToHide.add({
//           'item': oldItem,
//           'oldIndex': oldIndex,
//         });
//       } else if (newIndex != -1 && newIndex != oldIndex) {
//         itemsToMove.add({
//           'item': oldItem,
//           'oldIndex': oldIndex,
//           'newIndex': newIndex,
//         });
//       }
//     }

//     _items = newTodaysList;

//     //todo - Only move one item at a time, this is good???
//     Map<String, dynamic> itemToMove = {
//       'item': null,
//       'oldIndex': 0,
//       'newIndex': 0,
//     };
//     for (var item in itemsToMove) {
//       final itemDiff = (item['oldIndex'] - item['newIndex']).abs();
//       final itemToMoveDiff =
//           (itemToMove['oldIndex']! - itemToMove['newIndex']!).abs();
//       if (itemDiff > itemToMoveDiff) {
//         itemToMove = item;
//       }
//     }

//     if (itemsToShow.isNotEmpty) {
//       _showItems(itemsToShow);
//     }
//     if (itemsToHide.isNotEmpty) {
//       _hideItems(itemsToHide);
//     }
//     if (itemToMove['item'] != null &&
//         ((itemsToShow.isEmpty && itemsToHide.isEmpty))) {
//       _moveItem(itemToMove);
//     }
//   }

//   void _showItems(List<dynamic> items) async {
//     final newIndex = _items!.indexOf(items.first);
//     if (newIndex == -1) {
//       return;
//     }

//     _itemListKey.currentState!.insertAllItems(
//       newIndex,
//       items.length,
//       duration: _animationDuration,
//     );
//   }

//   void _hideItems(List<dynamic> itemMaps) async {
//     itemMaps.sort((a, b) => b['oldIndex'].compareTo(a['oldIndex']));

//     for (final itemMap in itemMaps) {
//       _itemListKey.currentState!.removeItem(
//         itemMap['oldIndex'],
//         (context, animation) {
//           return _buildItem(itemMap['item'], itemMap['oldIndex'], animation);
//         },
//         duration: _animationDuration,
//       );
//     }
//   }

//   void _moveItem(dynamic itemMap) async {
//     final oldIndex = itemMap['oldIndex'];
//     final newIndex = itemMap['newIndex'].clamp(0, _items!.length - 1);

//     if (oldIndex == -1 || newIndex == -1 || newIndex == oldIndex) {
//       return;
//     }

//     _itemListKey.currentState!.removeItem(
//       itemMap['oldIndex'],
//       (context, animation) {
//         return _buildItem(itemMap['item'], oldIndex, animation);
//       },
//       duration: _animationDuration,
//     );

//     _itemListKey.currentState!.insertItem(
//       newIndex,
//       duration: _animationDuration,
//     );
//   }

//   Widget _buildItem(dynamic item, int index, Animation<double> animation) {
//     return SizeTransition(
//       sizeFactor: animation,
//       child: FadeTransition(
//         opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
//         child: item is RoutineInstance
//             ? ExpandableRoutineListCard(
//                 key: ValueKey('${(item).routineId}-$date'),
//                 routineInstance: item,
//                 selectedDate: date,
//               )
//             : CheckableTaskListCard(
//                 key: ValueKey(
//                   '${(item as TaskInstance).taskId}-$date',
//                 ),
//                 taskInstance: item,
//                 selectedDate: date,
//               ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     //todo - figure out how to get the screen to update when the day changes
//     //DateTime currentDate = ref.watch(currentDateProvider);
//     // Combine the providers into a single watch for better efficiency
//     ref.watch(showCompletedProvider);
//     ref.watch(taskInstancesProvider);
//     ref.watch(routineInstancesProvider);

//     _updateSelectedDateList();

//     return SizedBox(
//       height: double.infinity,
//       width: double.infinity,
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 6),
//           child: Column(
//             children: [
//               AnimatedList(
//                 key: _itemListKey,
//                 initialItemCount: _items!.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index, animation) {
//                   return _buildItem(_items![index], index, animation);
//                 },
//               ),
//               const ShowCompletedItemsButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instances.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flow/src/features/date_check_list/presentation/task_instance_list_card.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateCheckList extends ConsumerWidget {
  const DateCheckList({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateTaskInstancesValue = ref.watch(dateTaskInstancesProvider(date));

    return AsyncValueWidget<TaskInstances>(
      value: dateTaskInstancesValue,
      data: (dateTaskInstances) {
        if (dateTaskInstances.taskInstancesList.isEmpty) {
          return Center(
            child: Text(
              'No tasks found'.hardcoded,
            ),
          );
        }

        final sortedTaskInstances = dateTaskInstances.sortTaskInstances();

        return Padding(
          padding: const EdgeInsets.only(top: Sizes.p8),
          child: ListView.builder(
            //todo - this is not good, figure out the good way to do this.
            shrinkWrap: true,
            // add one to display toggle button at the end of the list
            itemCount: sortedTaskInstances.taskInstancesList.length + 1,
            itemBuilder: (context, index) {
              if (index < sortedTaskInstances.taskInstancesList.length) {
                return TaskInstanceListCard(
                  taskInstance: sortedTaskInstances.taskInstancesList[index],
                );
              } else if (index ==
                  sortedTaskInstances.taskInstancesList.length) {
                //return toggleShowAllTaskInstances();
                return TextButton(
                  onPressed: () {},
                  child: const Text('toggle tasks'),
                );
              } else {
                return null;
              }
            },
          ),
        );
      },
    );
  }
}
