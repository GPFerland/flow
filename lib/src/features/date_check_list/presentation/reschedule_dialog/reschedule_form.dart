import 'package:flow/src/features/date_check_list/presentation/reschedule_dialog/reschedule_form_controller.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/localization/string_hardcoded.dart';
import 'package:flow/src/utils/async_value_ui.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RescheduleForm extends ConsumerWidget {
  const RescheduleForm({
    super.key,
    required this.taskInstance,
  });

  final TaskInstance taskInstance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      rescheduleFormControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(rescheduleFormControllerProvider);

    //todo - this form is shitty, make it easier to understand
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.edit_calendar_rounded),
          title: const Text('Scheduled'),
          trailing: Text(
            getTitleDateString(state.value!),
            style: getBodyMediumOnPrimaryContainer(context),
            overflow: TextOverflow.fade,
            maxLines: 1,
          ),
          onTap: () {
            ref
                .read(rescheduleFormControllerProvider.notifier)
                .selectRescheduledDate(context: context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_month),
          title: Text('Next On'.hardcoded),
          trailing: Text(
            'Next Date'.hardcoded,
            style: getBodyMediumOnPrimaryContainer(context),
            overflow: TextOverflow.fade,
            maxLines: 1,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                ref
                    .read(rescheduleFormControllerProvider.notifier)
                    .skipTaskInstance(taskInstance);
                context.pop();
              },
              child: Text('Skip'.hardcoded),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(rescheduleFormControllerProvider.notifier)
                    .rescheduleTaskInstance(taskInstance);
                context.pop();
              },
              child: Text('Save'.hardcoded),
            ),
          ],
        ),
      ],
    );
  }
}
