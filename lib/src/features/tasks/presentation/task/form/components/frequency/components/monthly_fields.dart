import 'package:flow/src/common_widgets/dividers/divider_on_primary_container.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';

class MonthlyFields extends StatefulWidget {
  const MonthlyFields({
    super.key,
    required this.monthdays,
    required this.updateMonthdays,
  });

  final List<Monthday> monthdays;
  final Function(List<Monthday>) updateMonthdays;

  // * Keys for testing using find.byKey()
  static const ordinalDropdownKey = Key('ordinalDropdown');
  static const weekdayDropdownKey = Key('weekdayDropdown');
  static const plusIconButtonKey = Key('plusIconButton');

  @override
  State<MonthlyFields> createState() => _MonthlyFieldsState();
}

class _MonthlyFieldsState extends State<MonthlyFields> {
  late List<Monthday> monthdays;
  Ordinal ordinal = Ordinal.first;
  Weekday weekday = Weekday.day;

  @override
  void initState() {
    super.initState();
    monthdays = widget.monthdays;
  }

  //todo - this is all a lil fucked up
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gapW12,
            DropdownButton<Ordinal>(
              key: MonthlyFields.ordinalDropdownKey,
              value: ordinal,
              onChanged: (Ordinal? selectedOrdinal) {
                setState(() {
                  ordinal = selectedOrdinal!;
                });
              },
              items: Ordinal.values.map((Ordinal value) {
                return DropdownMenuItem<Ordinal>(
                  value: value,
                  child: Text(value.longhand),
                );
              }).toList(),
            ),
            gapW12,
            DropdownButton<Weekday>(
              key: MonthlyFields.weekdayDropdownKey,
              value: weekday,
              onChanged: (Weekday? selectedWeekday) {
                setState(() {
                  weekday = selectedWeekday!;
                });
              },
              items: Weekday.values.map((Weekday value) {
                return DropdownMenuItem<Weekday>(
                  value: value,
                  child: Text(value.longhand),
                );
              }).toList(),
            ),
            IconButton(
              key: MonthlyFields.plusIconButtonKey,
              onPressed: () {
                setState(() {
                  monthdays.add(
                    Monthday(
                      weekday: weekday,
                      ordinal: ordinal,
                    ),
                  );
                  widget.updateMonthdays(
                    monthdays,
                  );
                });
              },
              icon: Icon(
                Icons.add,
                size: Sizes.p24,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
        if (monthdays.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.p8),
            child: DividerOnPrimaryContainer(),
          ),
        if (monthdays.isNotEmpty)
          Column(
            children: [
              for (Monthday monthday in monthdays)
                Padding(
                  padding: const EdgeInsets.fromLTRB(Sizes.p16, 0, Sizes.p8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${monthday.ordinal.longhand} ${monthday.weekday.longhand} of the month',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        color: Theme.of(context).colorScheme.onSurface,
                        onPressed: () {
                          setState(
                            () {
                              monthdays.remove(monthday);
                              widget.updateMonthdays(monthdays);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        if (monthdays.isEmpty) gapH8,
      ],
    );
  }
}
