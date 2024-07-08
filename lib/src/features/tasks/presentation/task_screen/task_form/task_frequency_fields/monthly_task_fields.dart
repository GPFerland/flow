import 'package:flow/src/common_widgets/dividers/divider_on_primary_container.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';

class MonthlyTaskFields extends StatefulWidget {
  const MonthlyTaskFields({
    super.key,
    required this.selectedMonthdays,
    required this.selectMonthdays,
  });

  final List<Monthday> selectedMonthdays;
  final Function(List<Monthday>) selectMonthdays;

  // * Keys for testing using find.byKey()
  static const ordinalDropdownKey = Key('ordinalDropdown');
  static const weekdayDropdownKey = Key('weekdayDropdown');
  static const plusIconButtonKey = Key('plusIconButton');

  @override
  State<MonthlyTaskFields> createState() => _MonthlyTaskFieldsState();
}

class _MonthlyTaskFieldsState extends State<MonthlyTaskFields> {
  Ordinal ordinal = Ordinal.first;
  Weekday weekday = Weekday.day;

  //todo - this is all a lil fucked up
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxWidth = constraints.maxWidth * 1;

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  gapW12,
                  DropdownButton<Ordinal>(
                    key: MonthlyTaskFields.ordinalDropdownKey,
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
                    key: MonthlyTaskFields.weekdayDropdownKey,
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
                    key: MonthlyTaskFields.plusIconButtonKey,
                    onPressed: () {
                      setState(() {
                        widget.selectedMonthdays.add(
                          Monthday(
                            weekday: weekday,
                            ordinal: ordinal,
                          ),
                        );
                        widget.selectMonthdays(
                          widget.selectedMonthdays,
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
              if (widget.selectedMonthdays.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.p8),
                  child: DividerOnPrimaryContainer(),
                ),
              if (widget.selectedMonthdays.isNotEmpty)
                Column(
                  children: [
                    for (Monthday selectedMonthday in widget.selectedMonthdays)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          Sizes.p16,
                          0,
                          Sizes.p8,
                          0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${selectedMonthday.ordinal.longhand} ${selectedMonthday.weekday.longhand} of the month',
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
                                    widget.selectedMonthdays.remove(
                                      selectedMonthday,
                                    );
                                    widget.selectMonthdays(
                                      widget.selectedMonthdays,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              if (widget.selectedMonthdays.isEmpty) gapH8,
            ],
          ),
        );
      },
    );
  }
}
