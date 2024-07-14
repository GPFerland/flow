import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';

class OnceFields extends StatefulWidget {
  const OnceFields({
    super.key,
    required this.date,
    required this.updateDate,
  });

  final DateTime date;
  final Function(DateTime date) updateDate;

  @override
  State<OnceFields> createState() => _OnceFieldsState();
}

class _OnceFieldsState extends State<OnceFields> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = widget.date;
  }

  Future<void> _selectDate() async {
    DateTime? newDate = await selectDate(
      context: context,
      initialDate: date,
    );
    if (newDate != null && newDate != date) {
      setState(() {
        date = newDate;
        widget.updateDate(getDateNoTime(date));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _selectDate,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p12,
          vertical: Sizes.p8,
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
                      gapW8,
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
                  padding: const EdgeInsets.all(Sizes.p8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    getFormattedDateString(date),
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
