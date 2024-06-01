import 'package:flow/utils/date.dart';
import 'package:flow/utils/style.dart';
import 'package:flutter/material.dart';

class OneTimeTaskFields extends StatefulWidget {
  const OneTimeTaskFields({
    super.key,
    required this.selectedDate,
    required this.selectDate,
  });

  final DateTime selectedDate;
  final Function(DateTime selectedDate) selectDate;

  @override
  State<OneTimeTaskFields> createState() => _OneTimeTaskFieldsState();
}

class _OneTimeTaskFieldsState extends State<OneTimeTaskFields> {
  Future<void> _selectDate() async {
    DateTime? newDate = await selectDate(
      context: context,
      initialDate: widget.selectedDate,
    );
    if (newDate != null && newDate != widget.selectedDate) {
      widget.selectDate(getDateNoTime(newDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.calendar_today,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      title: Text(
        'Select Date',
        style: getBodyLargeOnPrimaryContainer(context, fontSize: 18),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          getFormattedDateString(widget.selectedDate),
          style: getTitleMediumOnPrimaryContainer(context),
        ),
      ),
      onTap: () {
        _selectDate();
      },
    );
  }
}
