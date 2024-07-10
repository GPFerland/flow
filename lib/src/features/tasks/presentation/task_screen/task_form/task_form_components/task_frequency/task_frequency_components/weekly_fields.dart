import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';

class WeeklyFields extends StatefulWidget {
  const WeeklyFields({
    super.key,
    required this.weekdays,
    required this.updateWeekdays,
  });

  final List<Weekday> weekdays;
  final Function(List<Weekday>) updateWeekdays;

  @override
  State<WeeklyFields> createState() => _WeeklyFieldsState();
}

class _WeeklyFieldsState extends State<WeeklyFields> {
  late List<Weekday> weekdays;

  @override
  void initState() {
    super.initState();
    weekdays = widget.weekdays;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: Sizes.p20,
            right: Sizes.p8,
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today),
              gapW8,
              const Text(
                'Select Days',
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    weekdays =
                        Weekday.values.take(Weekday.values.length - 1).toList();
                    widget.updateWeekdays(weekdays);
                  });
                },
                child: const Text('All'),
              ),
              Container(
                width: 2,
                height: Sizes.p20,
                color: Colors.grey,
              ),
              gapW4,
              TextButton(
                onPressed: () {
                  setState(() {
                    weekdays = [];
                    widget.updateWeekdays(weekdays);
                  });
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final buttonWidth = constraints.maxWidth / 8;
            return ToggleButtons(
              borderRadius: BorderRadius.circular(Sizes.p8),
              borderWidth: 2,
              constraints: BoxConstraints.tight(Size.square(buttonWidth)),
              textStyle: Theme.of(context).textTheme.bodySmall,
              isSelected: Weekday.values
                  .take(Weekday.values.length - 1)
                  .map((weekday) => weekdays.contains(weekday))
                  .toList(),
              fillColor: Theme.of(context).colorScheme.primary,
              selectedColor: Theme.of(context).colorScheme.onPrimary,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              onPressed: (index) {
                setState(() {
                  Weekday pressedWeekday = Weekday.values[index];
                  if (weekdays.contains(pressedWeekday)) {
                    weekdays.remove(pressedWeekday);
                  } else {
                    weekdays.add(pressedWeekday);
                  }
                  widget.updateWeekdays(weekdays);
                });
              },
              children: Weekday.values
                  .take(Weekday.values.length - 1)
                  .map(
                    (weekday) => Text(
                      weekday.shorthand,
                      key: weekday.weekdayButtonKey,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                  )
                  .toList(),
            );
          },
        ),
        gapH12,
      ],
    );
  }
}
