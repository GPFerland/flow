import 'package:flow/src/features/date_check_list/data/date_repository.dart';
import 'package:flow/src/features/date_check_list/presentation/reschedule_dialog/reschedule_form_controller.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/utils/async_value_ui.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RescheduleForm extends ConsumerStatefulWidget {
  const RescheduleForm({
    super.key,
    required this.taskInstance,
  });

  final TaskInstance taskInstance;

  @override
  ConsumerState<RescheduleForm> createState() {
    return _RescheduleTaskFormState();
  }
}

class _RescheduleTaskFormState extends ConsumerState<RescheduleForm> {
  DateTime? rescheduledDate;

  Future<void> _selectDate() async {
    // DateTime firstDate = getDateNoTime(DateTime.now());
    // firstDate =
    //     firstDate.isBefore(rescheduledDate!) ? firstDate : rescheduledDate!;

    // DateTime? lastDate = widget.task.getNextScheduledDate(rescheduledDate!);
    // lastDate = lastDate.subtract(
    //   const Duration(days: 1),
    // );

    DateTime? newDate = await selectDate(
      context: context,
      initialDate: rescheduledDate!,
      //firstDate: firstDate,
      //lastDate: lastDate,
    );

    if (newDate != null) {
      setState(() {
        rescheduledDate = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      rescheduleFormControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    //final state = ref.watch(rescheduleFormControllerProvider);
    rescheduledDate ??= ref.read(dateRepositoryProvider).date;

    //todo - this form is shitty, make it easier to understand
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text(
          'title',
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.edit_calendar_rounded),
          title: const Text(
            'Scheduled',
          ),
          trailing: Text(
            getDisplayDateString(rescheduledDate!),
            style: getBodyMediumOnPrimaryContainer(context),
            overflow: TextOverflow.fade,
            maxLines: 1,
          ),
          onTap: () {
            _selectDate();
          },
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.calendar_month),
          title: Text(
            'Next On',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Text(
            'Next Date',
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
                    .skipTaskInstance(widget.taskInstance);
                Navigator.pop(context);
              },
              child: const Text('Skip Task'),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(rescheduleFormControllerProvider.notifier)
                    .rescheduleTaskInstance(
                      widget.taskInstance,
                      rescheduledDate!,
                    );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ]),
    );
  }
}
