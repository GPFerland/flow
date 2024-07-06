import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';

class WeeklyTaskFields extends StatefulWidget {
  const WeeklyTaskFields({
    super.key,
    required this.selectedWeekdays,
    required this.selectWeekdays,
  });

  final List<Weekday> selectedWeekdays;
  final Function(List<Weekday>) selectWeekdays;

  @override
  State<WeeklyTaskFields> createState() => _WeeklyTaskFieldsState();
}

class _WeeklyTaskFieldsState extends State<WeeklyTaskFields> {
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
                    widget.selectWeekdays(
                      Weekday.values.take(Weekday.values.length - 1).toList(),
                    );
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
                    widget.selectWeekdays([]);
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
                  .map((weekday) => widget.selectedWeekdays.contains(weekday))
                  .toList(),
              fillColor: Theme.of(context).colorScheme.primary,
              selectedColor: Theme.of(context).colorScheme.onPrimary,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              onPressed: (index) {
                setState(() {
                  Weekday pressedWeekday = Weekday.values[index];
                  if (widget.selectedWeekdays.contains(pressedWeekday)) {
                    widget.selectedWeekdays.remove(pressedWeekday);
                  } else {
                    widget.selectedWeekdays.add(pressedWeekday);
                  }
                  widget.selectWeekdays(widget.selectedWeekdays);
                });
              },
              children: Weekday.values
                  .take(Weekday.values.length - 1)
                  .map(
                    (weekday) => Text(
                      weekday.shorthand,
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
