import 'package:flow/utils/date.dart';
import 'package:flow/utils/style.dart';
import 'package:flow/widgets/dividers/divider_on_primary_container.dart';
import 'package:flutter/material.dart';

class MonthlyTaskFields extends StatefulWidget {
  const MonthlyTaskFields({
    super.key,
    required this.selectedMonthDays,
  });

  final List<Map<String, dynamic>> selectedMonthDays;

  @override
  State<MonthlyTaskFields> createState() => _MonthlyTaskFieldsState();
}

class _MonthlyTaskFieldsState extends State<MonthlyTaskFields> {
  String? when = 'First';
  String? whatDay = 'Day';

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
                  const SizedBox(
                    width: 12,
                  ),
                  DropdownButton<String>(
                    items: [
                      for (String monthlyWhen in monthlyOrdinalsMap.values)
                        DropdownMenuItem(
                          value: monthlyWhen,
                          child: Text(
                            monthlyWhen,
                            style: getTitleSmallOnPrimaryContainer(context),
                          ),
                          onTap: () {
                            setState(() {
                              when = monthlyWhen;
                            });
                          },
                        ),
                    ],
                    value: when,
                    onChanged: (String? selected) {},
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  DropdownButton<String>(
                    items: [
                      for (String monthlyWhatDay in monthlyWeekdaysMap.values)
                        DropdownMenuItem(
                          value: monthlyWhatDay,
                          child: Text(
                            monthlyWhatDay,
                            style: getTitleSmallOnPrimaryContainer(context),
                          ),
                          onTap: () {
                            setState(() {
                              whatDay = monthlyWhatDay;
                            });
                          },
                        ),
                    ],
                    value: whatDay,
                    onChanged: (String? selected) {},
                  ),
                  IconButton(
                    onPressed: () {
                      if (when != null && whatDay != null) {
                        setState(() {
                          widget.selectedMonthDays.add({
                            'when': when!,
                            'whatDay': whatDay!,
                          });
                        });
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      size: 24,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              if (widget.selectedMonthDays.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: DividerOnPrimaryContainer(),
                ),
              if (widget.selectedMonthDays.isNotEmpty)
                Column(
                  children: [
                    for (Map<String, dynamic> selectedMonthDay
                        in widget.selectedMonthDays)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${selectedMonthDay['when']} ${selectedMonthDay['whatDay']} of the month',
                                style: getBodySmallOnPrimaryContainer(context),
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
                                    widget.selectedMonthDays
                                        .remove(selectedMonthDay);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              if (widget.selectedMonthDays.isEmpty)
                const SizedBox(
                  height: 8,
                ),
            ],
          ),
        );
      },
    );
  }
}
