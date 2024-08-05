import 'package:flow/src/features/tasks/presentation/task/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskUntilCompletedSwitch extends ConsumerStatefulWidget {
  const TaskUntilCompletedSwitch({
    super.key,
    required this.untilCompleted,
    required this.updateUntilCompleted,
  });

  final bool untilCompleted;
  final Function(bool) updateUntilCompleted;

  // * Keys for testing using find.byKey()
  static const untilCompletedKey = Key('untilCompleted');

  @override
  ConsumerState<TaskUntilCompletedSwitch> createState() {
    return _UntilCompletedToggleSliderState();
  }
}

class _UntilCompletedToggleSliderState
    extends ConsumerState<TaskUntilCompletedSwitch> {
  late bool untilCompleted;

  @override
  void initState() {
    super.initState();
    untilCompleted = widget.untilCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskControllerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Expanded(
            child: Row(
              children: [
                Text(
                  'Show Until Completed',
                ),
                //todo - this isnt working like I would expect???
                // const SizedBox(width: 8),
                // Tooltip(
                //   message: 'Test.',
                //   triggerMode: TooltipTriggerMode.tap,
                //   child: IconButton(
                //     icon: const Icon(Icons.info, size: 18),
                //     onPressed: () {},
                //   ),
                // ),
              ],
            ),
          ),
          Switch(
            key: TaskUntilCompletedSwitch.untilCompletedKey,
            value: untilCompleted,
            onChanged: state.isLoading
                ? null
                : (value) {
                    setState(
                      () {
                        untilCompleted = value;
                        widget.updateUntilCompleted(untilCompleted);
                      },
                    );
                  },
          ),
        ],
      ),
    );
  }
}
