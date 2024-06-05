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
    return InkWell(
      onTap: _selectDate,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final maxWidth = constraints.maxWidth / 2;

            return Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Select Date',
                        style: getBodyMediumOnPrimaryContainer(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: maxWidth,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    getFormattedDateString(widget.selectedDate),
                    style: getBodyMediumOnPrimary(context),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
