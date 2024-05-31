import 'package:flow/models/occurrence.dart';
import 'package:flow/models/routine.dart';
import 'package:flow/models/task.dart';
import 'package:flow/providers/date/selected_date_provider.dart';
import 'package:flow/providers/future/selected_date_list_data_future_provider.dart';
import 'package:flow/providers/models/occurrences_provider.dart';
import 'package:flow/providers/models/routines_provider.dart';
import 'package:flow/providers/models/tasks_provider.dart';
import 'package:flow/providers/theme/show_completed_provider.dart';
import 'package:flow/widgets/dividers/divider_on_primary_container.dart';
import 'package:flow/widgets/list_tiles/routine_list_tiles/expandable_routine_list_tile.dart';
import 'package:flow/widgets/list_tiles/task_list_tiles/checkable_task_list_tile.dart';
import 'package:flow/widgets/lists/shimmer_loading_task_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDateList extends ConsumerStatefulWidget {
  const SelectedDateList({super.key});

  @override
  ConsumerState<SelectedDateList> createState() {
    return _SelectedDateListState();
  }
}

class _SelectedDateListState extends ConsumerState<SelectedDateList>
    with SingleTickerProviderStateMixin {
  late DateTime _selectedDate;
  late List<dynamic>? _items;
  final GlobalKey<AnimatedListState> _itemListKey =
      GlobalKey<AnimatedListState>();
  late AnimationController _animationController;
  final Duration _animationDuration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _selectedDate = ref.read(selectedDateProvider);
    _items = null;
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<dynamic> _getSelectedDateList() {
    final List<Occurrence> occurences = ref.read(occurrencesProvider);
    final List<Routine> routines = ref.read(routinesProvider);
    final List<Task> tasks = ref.read(tasksProvider);
    final bool showCompleted = ref.read(showCompletedProvider);

    final List<Task> selectedDateTasks = [];
    for (Task task in tasks) {
      for (Occurrence occurrence in occurences) {
        if (occurrence.taskId == task.id) {
          task.addOccurrence(occurrence);
        }
      }

      if (task.isScheduled(_selectedDate)) {
        if (task.occurrences != null && task.occurrences!.isNotEmpty) {
          Occurrence? matchingOccurrence = getMatchingOccurrence(
            task.occurrences!,
            _selectedDate,
          );
          if (matchingOccurrence == null) {
            selectedDateTasks.add(task);
          } else if (matchingOccurrence.isRequired(_selectedDate)) {
            selectedDateTasks.add(task);
          }
        } else {
          selectedDateTasks.add(task);
        }
      } else if (task.isRescheduled(_selectedDate)) {
        selectedDateTasks.add(task);
      } else if (task.isOverdue(_selectedDate)) {
        selectedDateTasks.add(task);
      }
    }

    final List<Task> completedTasks = [];
    for (Task task in selectedDateTasks) {
      if (task.isComplete(_selectedDate)) {
        completedTasks.add(task);
      }
    }

    final List<Task> uncompletedTasks = [];
    for (Task task in selectedDateTasks) {
      if (!completedTasks.contains(task)) {
        uncompletedTasks.add(task);
      }
    }

    List<Routine> selectedDateRoutines = [];
    for (Routine routine in routines) {
      routine.tasks = [];
      for (Task task in selectedDateTasks) {
        if (task.routineId == routine.id) {
          routine.addTask(task);
          if (!selectedDateRoutines.contains(routine)) {
            selectedDateRoutines.add(routine);
          }
          completedTasks.remove(task);
          uncompletedTasks.remove(task);
        }
      }
    }

    final List<Routine> completedRoutines = [];
    for (Routine routine in selectedDateRoutines) {
      if (routine.isComplete(_selectedDate)) {
        completedRoutines.add(routine);
      }
    }

    final List<Routine> uncompletedRoutines = [];
    for (Routine routine in selectedDateRoutines) {
      if (!completedRoutines.contains(routine)) {
        uncompletedRoutines.add(routine);
      }
    }

    List<dynamic> selectedDateCompletedList = _combineAndSortTasksAndRoutines(
      _selectedDate,
      completedRoutines,
      completedTasks,
      true,
    );

    List<dynamic> selectedDateUncompletedList = _combineAndSortTasksAndRoutines(
      _selectedDate,
      uncompletedRoutines,
      uncompletedTasks,
      false,
    );

    List<dynamic> selectedDateList = [];
    if (showCompleted) {
      selectedDateList = [
        ...selectedDateUncompletedList,
        ...selectedDateCompletedList,
      ];
    } else {
      selectedDateList = [
        ...selectedDateUncompletedList,
      ];
    }

    return selectedDateList;
  }

  void _updateSelectedDateList() {
    bool isNewDate = _selectedDate != ref.read(selectedDateProvider);
    if (isNewDate) {
      _selectedDate = ref.read(selectedDateProvider);
    }

    List<dynamic> newTodaysList = _getSelectedDateList();

    if (_items == null) {
      _items = newTodaysList;
      return;
    }

    List<dynamic> itemsToShow = [];
    List<dynamic> itemsToHide = [];
    List<dynamic> itemsToMove = [];

    for (var newItem in newTodaysList) {
      if (!_items!.contains(newItem)) {
        itemsToShow.add(newItem);
      }
    }

    for (var oldItem in _items!) {
      final newIndex = newTodaysList.indexOf(oldItem);
      final oldIndex = _items!.indexOf(oldItem);
      if (newIndex == -1 && oldIndex != -1) {
        itemsToHide.add({
          'item': oldItem,
          'oldIndex': oldIndex,
        });
      } else if (newIndex != -1 && newIndex != oldIndex) {
        itemsToMove.add({
          'item': oldItem,
          'oldIndex': oldIndex,
          'newIndex': newIndex,
        });
      }
    }

    _items = newTodaysList;

    //todo - Only move one item at a time, this is good???
    Map<String, dynamic> itemToMove = {
      'item': null,
      'oldIndex': 0,
      'newIndex': 0,
    };
    for (var item in itemsToMove) {
      final itemDiff = (item['oldIndex'] - item['newIndex']).abs();
      final itemToMoveDiff =
          (itemToMove['oldIndex']! - itemToMove['newIndex']!).abs();
      if (itemDiff > itemToMoveDiff) {
        itemToMove = item;
      }
    }

    if (itemsToShow.isNotEmpty) {
      _showItems(itemsToShow);
    }
    if (itemsToHide.isNotEmpty) {
      _hideItems(itemsToHide);
    }
    if (!isNewDate &&
        itemToMove['item'] != null &&
        ((itemsToShow.isEmpty && itemsToHide.isEmpty))) {
      _moveItem(itemToMove);
    }
  }

  List<dynamic> _combineAndSortTasksAndRoutines(
    DateTime selectedDate,
    List<Routine> routines,
    List<Task> tasks,
    bool complete,
  ) {
    List<dynamic> combinedList = [...routines, ...tasks];

    combinedList.sort(
      (a, b) {
        if (a is Routine && b is Routine) {
          if (complete) {
            return a.getHighestTaskPriority(selectedDate).compareTo(
                  b.getHighestTaskPriority(selectedDate),
                );
          } else {
            return a.getHighestUncompletedTaskPriority(selectedDate).compareTo(
                  b.getHighestUncompletedTaskPriority(selectedDate),
                );
          }
        } else if (a is Task && b is Task) {
          return a.priority!.compareTo(b.priority!);
        } else if (a is Routine && b is Task) {
          if (complete) {
            return a
                .getHighestTaskPriority(selectedDate)
                .compareTo(b.priority!);
          } else {
            return a
                .getHighestUncompletedTaskPriority(selectedDate)
                .compareTo(b.priority!);
          }
        } else {
          if (complete) {
            return a.priority!.compareTo(
              b.getHighestTaskPriotity(selectedDate),
            );
          } else {
            return a.priority!.compareTo(
              b.getHighestUncompletedTaskPriority(selectedDate),
            );
          }
        }
      },
    );

    final List<dynamic> expandedList = [];
    for (var item in combinedList) {
      expandedList.add(item);
      if (item is Routine && item.isExpanded == true) {
        expandedList.addAll(
          item.tasks!
            ..sort((a, b) =>
                (a.isComplete(selectedDate) ? 1 : 0) -
                (b.isComplete(selectedDate) ? 1 : 0)),
        );
      }
    }

    return expandedList;
  }

  void _showItems(List<dynamic> items) async {
    final newIndex = _items!.indexOf(items.first);
    if (newIndex == -1) {
      return;
    }

    _itemListKey.currentState!.insertAllItems(
      newIndex,
      items.length,
      duration: _animationDuration,
    );
  }

  void _hideItems(List<dynamic> itemMaps) async {
    itemMaps.sort((a, b) => b['oldIndex'].compareTo(a['oldIndex']));

    for (final itemMap in itemMaps) {
      _itemListKey.currentState!.removeItem(
        itemMap['oldIndex'],
        (context, animation) {
          return _buildItem(itemMap['item'], itemMap['oldIndex'], animation);
        },
        duration: _animationDuration,
      );
    }
  }

  void _moveItem(dynamic itemMap) async {
    final oldIndex = itemMap['oldIndex'];
    final newIndex = itemMap['newIndex'].clamp(0, _items!.length - 1);

    if (oldIndex == -1 || newIndex == -1 || newIndex == oldIndex) {
      return;
    }

    _itemListKey.currentState!.removeItem(
      itemMap['oldIndex'],
      (context, animation) {
        return _buildItem(itemMap['item'], oldIndex, animation);
      },
      duration: _animationDuration,
    );

    _itemListKey.currentState!.insertItem(
      newIndex,
      duration: _animationDuration,
    );
  }

  Widget _buildItem(dynamic item, int index, Animation<double> animation) {
    final globalKey = GlobalKey();

    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        // Fade in/out animation
        opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
        child: Column(
          children: [
            item is Routine
                ? ExpandableRoutineListTile(
                    key: globalKey, // Assign the key for positioning
                    routine: item,
                  )
                : CheckableTaskListTile(
                    key: globalKey, // Assign the key for positioning
                    task: item,
                    routine: item.routineId != null
                        ? ref
                            .read(routinesProvider.notifier)
                            .getRoutineFromId(item.routineId)
                        : null,
                  ),
            const DividerOnPrimaryContainer(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //todo - figure out how to get the screen to update when the day changes
    //DateTime currentDate = ref.watch(currentDateProvider);
    ref.watch(selectedDateProvider);
    ref.watch(showCompletedProvider);
    ref.watch(occurrencesProvider);
    ref.watch(routinesProvider);
    ref.watch(tasksProvider);

    return ref.watch(selectedDateListDataFutureProvider).when(
      loading: () {
        return const ShimmerLoadingList();
      },
      data: (data) {
        _updateSelectedDateList();

        return AnimatedList(
          key: _itemListKey,
          initialItemCount: _items!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index, animation) {
            return _buildItem(_items![index], index, animation);
          },
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      },
    );
  }
}
