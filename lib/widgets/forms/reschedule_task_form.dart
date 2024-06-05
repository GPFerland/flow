import 'package:flow/data/models/task.dart';
import 'package:flow/utils/date.dart';
import 'package:flow/utils/style.dart';
import 'package:flow/widgets/buttons/reschedule_task_button.dart';
import 'package:flow/widgets/buttons/skip_task_button.dart';
import 'package:flow/widgets/dividers/divider_on_primary_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleTaskForm extends ConsumerStatefulWidget {
  const ScheduleTaskForm({
    super.key,
    required this.task,
    required this.date,
  });

  final Task task;
  final DateTime date;

  @override
  ConsumerState<ScheduleTaskForm> createState() {
    return _RescheduleTaskFormState();
  }
}

class _RescheduleTaskFormState extends ConsumerState<ScheduleTaskForm> {
  DateTime? rescheduledDate;

  Future<void> _selectDate() async {
    DateTime firstDate = getDateNoTime(DateTime.now());
    firstDate = firstDate.isBefore(rescheduledDate ?? widget.date)
        ? firstDate
        : widget.date;

    DateTime? lastDate = widget.task.getNextOccurrence(widget.date);
    if (lastDate != null) {
      lastDate = lastDate.subtract(
        const Duration(days: 1),
      );
    }

    DateTime? newDate = await selectDate(
      context: context,
      initialDate: rescheduledDate ?? widget.date,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (newDate != null) {
      setState(() {
        rescheduledDate = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? nextOccurrence = widget.task.getNextOccurrence(widget.date);
    rescheduledDate ??= widget.date;

    //todo - this form is shitty, make it easier to understand
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
          widget.task.title!,
          style: getTitleLargeOnPrimaryContainer(context),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: DividerOnPrimaryContainer(),
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.edit_calendar_rounded),
          title: Text(
            'Scheduled',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Text(
            getFormattedDateString(rescheduledDate!),
            style: getBodyMediumOnPrimaryContainer(context),
            overflow: TextOverflow.fade,
            maxLines: 1,
          ),
          onTap: () {
            _selectDate();
          },
        ),
        if (nextOccurrence != null)
          ListTile(
            dense: true,
            leading: const Icon(Icons.calendar_month),
            title: Text(
              'Next On',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Text(
              getFormattedDateString(nextOccurrence),
              style: getBodyMediumOnPrimaryContainer(context),
              overflow: TextOverflow.fade,
              maxLines: 1,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SkipTaskButton(
              task: widget.task,
              date: widget.date,
            ),
            RescheduleTaskButton(
              task: widget.task,
              date: widget.date,
              rescheduledDate: rescheduledDate!,
            )
          ],
        ),
      ]),
    );
  }
}
