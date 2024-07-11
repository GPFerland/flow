import 'package:flow/src/features/tasks/presentation/task/form/components/frequency/components/daily_fields.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/frequency/components/monthly_fields.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/frequency/components/once_fields.dart';
import 'package:flow/src/features/tasks/presentation/task/form/components/frequency/components/weekly_fields.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskFrequencyTabs extends ConsumerStatefulWidget {
  const TaskFrequencyTabs({
    super.key,
    required this.frequency,
    required this.updateFrequency,
    required this.date,
    required this.updateDate,
    required this.weekdays,
    required this.updateWeekdays,
    required this.monthdays,
    required this.updateMonthdays,
  });

  final Frequency frequency;
  final Function(Frequency) updateFrequency;
  final DateTime date;
  final Function(DateTime) updateDate;
  final List<Weekday> weekdays;
  final Function(List<Weekday>) updateWeekdays;
  final List<Monthday> monthdays;
  final Function(List<Monthday>) updateMonthdays;

  @override
  ConsumerState<TaskFrequencyTabs> createState() {
    return _TaskFrequencyTabsState();
  }
}

class _TaskFrequencyTabsState extends ConsumerState<TaskFrequencyTabs>
    with SingleTickerProviderStateMixin {
  late TabController _frequencyTabController;

  @override
  void initState() {
    super.initState();
    _frequencyTabController = TabController(
      length: Frequency.values.length,
      vsync: this,
      initialIndex: Frequency.values.indexOf(widget.frequency),
    );
    _frequencyTabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _frequencyTabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_frequencyTabController.indexIsChanging) {
      setState(() {
        widget.updateFrequency(
          Frequency.values[_frequencyTabController.index],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          TabBar(
            controller: _frequencyTabController,
            tabs: Frequency.values.map((frequency) {
              return Tab(
                key: frequency.tabKey,
                child: Text(
                  frequency.shorthand,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              );
            }).toList(),
          ),
          Center(
            child: [
              OnceFields(
                date: widget.date,
                updateDate: widget.updateDate,
              ),
              const DailyFields(),
              WeeklyFields(
                weekdays: widget.weekdays,
                updateWeekdays: widget.updateWeekdays,
              ),
              MonthlyFields(
                monthdays: widget.monthdays,
                updateMonthdays: widget.updateMonthdays,
              ),
            ][_frequencyTabController.index],
          )
        ],
      ),
    );
  }
}
