import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';

Task createTestTask({String id = '1'}) {
  return Task(
    id: id,
    createdOn: getDateNoTimeToday(),
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
