import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';

Task createTestTask() {
  return Task(
    id: '1',
    createdOn: DateTime.now(),
    title: 'Brush Teeth',
    icon: Icons.abc,
    color: Colors.blue,
    description: 'Brush Teeth in the Morning',
    showUntilCompleted: false,
    frequencyType: FrequencyType.daily,
    date: getDateNoTimeToday(),
    weekdays: [],
    monthdays: [],
  );
}
