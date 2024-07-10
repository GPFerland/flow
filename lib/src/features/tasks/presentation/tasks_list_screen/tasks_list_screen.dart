import 'package:flow/src/common_widgets/buttons/add_item_icon_button.dart';
import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/common_widgets/empty_placeholder_widget.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/tasks/application/tasks_service.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/presentation/tasks_list_screen/task_list_card/task_list_card.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flow/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksListScreen extends ConsumerWidget {
  const TasksListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksValue = ref.watch(tasksStreamProvider);

    Widget getListContent(List<Task> tasks) {
      if (tasks.isEmpty) {
        return SliverToBoxAdapter(
          child: EmptyPlaceholderWidget(
            message: 'Create a task...'.hardcoded,
          ),
        );
      } else {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final task = tasks[index];
              return TaskListCard(task: task);
            },
            childCount: tasks.length,
          ),
        );
      }
    }

    return Scaffold(
      body: AsyncValueWidget<List<Task>>(
        value: tasksValue,
        data: (tasks) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text('Tasks'),
                centerTitle: true,
                actions: [
                  AddItemIconButton(
                    namedRoute: AppRoute.createTask.name,
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(Sizes.p12),
                sliver: getListContent(tasks),
              ),
            ],
          );
        },
      ),
    );
  }
}
