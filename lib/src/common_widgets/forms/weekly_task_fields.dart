import 'package:flow/src/utils/date.dart';
import 'package:flow/src/utils/style.dart';
import 'package:flutter/material.dart';

class WeeklyTaskFields extends StatefulWidget {
  const WeeklyTaskFields({
    super.key,
    required this.selectedWeekDays,
  });

  final Map<String, bool> selectedWeekDays;

  @override
  State<WeeklyTaskFields> createState() => _WeeklyTaskFieldsState();
}

class _WeeklyTaskFieldsState extends State<WeeklyTaskFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 6),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Select Days',
                style: getBodyMediumOnPrimaryContainer(context),
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    for (String day in widget.selectedWeekDays.keys) {
                      widget.selectedWeekDays[day] = true;
                    }
                  });
                },
                child: Text(
                  'All',
                  style: getBodyMediumOnPrimaryContainer(context),
                ),
              ),
              Container(
                width: 2, // Adjust width as needed
                height: 20, // Adjust height as needed
                color: Colors.grey, // Set color of the line
              ),
              const SizedBox(
                width: 4,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    for (String day in widget.selectedWeekDays.keys) {
                      widget.selectedWeekDays[day] = false;
                    }
                  });
                },
                child: Text(
                  'Clear',
                  style: getBodyMediumOnPrimaryContainer(context),
                ),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final buttonWidth = constraints.maxWidth / 8;
            return ToggleButtons(
              borderRadius: BorderRadius.circular(16),
              borderWidth: 2,
              constraints: BoxConstraints.tight(Size.square(buttonWidth)),
              textStyle: Theme.of(context).textTheme.bodySmall,
              isSelected: widget.selectedWeekDays.values.toList(),
              fillColor: Theme.of(context).colorScheme.primary,
              selectedColor: Theme.of(context).colorScheme.onPrimary,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              onPressed: (index) {
                setState(() {
                  widget.selectedWeekDays[shorthandWeekdays[index]] =
                      !widget.selectedWeekDays[shorthandWeekdays[index]]!;
                });
              },
              children: shorthandWeekdays
                  .map(
                    (day) => Text(
                      day,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
