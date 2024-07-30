import 'package:collection/collection.dart';
import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/check_list/data/task_display_repository.dart';
import 'package:flow/src/features/check_list/presentation/check_list/components/card/check_list_card.dart';
import 'package:flow/src/features/check_list/presentation/check_list/components/toggle_display_button.dart';
import 'package:flow/src/features/check_list/presentation/check_list_controller.dart';
import 'package:flow/src/features/task_instances/application/task_instances_service.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckList extends ConsumerStatefulWidget {
  const CheckList({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  ConsumerState<CheckList> createState() {
    return _CheckListState();
  }
}

class _CheckListState extends ConsumerState<CheckList>
    with SingleTickerProviderStateMixin {
  List<dynamic> _items = [];
  final GlobalKey<AnimatedListState> _itemListKey =
      GlobalKey<AnimatedListState>();
  late AnimationController _animationController;
  final Duration _animationDuration = const Duration(milliseconds: 250);
  int? currentCombinedProviderHash;

  @override
  void initState() {
    super.initState();
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

  void _updateSelectedDateList(List<dynamic> checkList) {
    if (_itemListKey.currentState == null) {
      _items = checkList;
      return;
    }

    final deepEq = const DeepCollectionEquality().equals;
    if (deepEq(_items, checkList)) {
      return;
    }

    List<dynamic> itemsToShow = [];
    List<dynamic> itemsToHide = [];
    List<dynamic> itemsToMove = [];

    for (var newItem in checkList) {
      if (!_items.contains(newItem)) {
        itemsToShow.add(newItem);
      }
    }

    for (var oldItem in _items) {
      final newIndex = checkList.indexOf(oldItem);
      final oldIndex = _items.indexOf(oldItem);
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

    _items = checkList;

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
    if (itemToMove['item'] != null &&
        ((itemsToShow.isEmpty && itemsToHide.isEmpty))) {
      _moveItem(itemToMove);
    }
  }

  void _showItems(List<dynamic> items) async {
    final newIndex = _items.indexOf(items.first);
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
    final newIndex = itemMap['newIndex'].clamp(0, _items.length - 1);

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
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
        child: CheckListCard(
          key: ValueKey((item as TaskInstance).id),
          taskInstance: item,
          date: widget.date,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final dateTaskInstancesValue = ref.watch(
      dateTaskInstancesStreamProvider(widget.date),
    );

    return AsyncValueWidget<List<TaskInstance>>(
      value: dateTaskInstancesValue,
      data: (dateTaskInstances) {
        if (dateTaskInstances.isEmpty) {
          return Center(
            child: Text(
              'No tasks today'.hardcoded,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: Sizes.p8),
          child: Consumer(
            builder: (context, listRef, child) {
              listRef.watch(taskDisplayStreamProvider).value;
              final sortedTaskInstances = listRef
                  .read(checkListControllerProvider.notifier)
                  .sortTaskInstances(List.from(dateTaskInstances));

              _updateSelectedDateList(sortedTaskInstances);

              return Column(
                children: [
                  AnimatedList(
                    key: _itemListKey,
                    initialItemCount: _items.length,
                    // todo - shrinkWrap is ass
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index, animation) {
                      return _buildItem(_items[index], index, animation);
                    },
                  ),
                  const ToggleDisplayButton(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
