import 'package:flow/utils/date.dart';
import 'package:flow/utils/style.dart';
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
                width: 16,
              ),
              Text(
                'Select Days',
                style: getBodyLargeOnPrimaryContainer(context, fontSize: 18),
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
                  style: getBodyLargeOnPrimaryContainer(context),
                ),
              ),
              Container(
                width: 2, // Adjust width as needed
                height: 20, // Adjust height as needed
                color: Colors.grey, // Set color of the line
              ),
              const SizedBox(
                width: 6,
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
                  style: getBodyLargeOnPrimaryContainer(context),
                ),
              ),
            ],
          ),
        ),
        ToggleButtons(
          borderRadius: BorderRadius.circular(16),
          borderWidth: 2,
          constraints: BoxConstraints.tight(const Size.square(44)),
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
                ),
              )
              .toList(),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
