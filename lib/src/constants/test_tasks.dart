import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/features/tasks/domain/tasks.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';

/// Test tasks to be used until a data source is implemented
final kTestTasks = Tasks(
  tasksList: [
    Task(
      id: '1',
      createdOn: DateTime.now(),
      title: 'Brush Teeth',
      icon: Icons.abc,
      color: Colors.blue,
      description: 'Brush Teeth in the Morning',
      untilCompleted: false,
      frequencyType: FrequencyType.daily,
      date: getDateNoTimeToday(),
      weekdays: [],
      monthdays: [],
    ),
    Task(
      id: '2',
      createdOn: DateTime.now(),
      title: 'Floss',
      icon: Icons.abc,
      color: Colors.blue,
      description: 'Floss in the Morning',
      untilCompleted: false,
      frequencyType: FrequencyType.daily,
      date: getDateNoTimeToday(),
      weekdays: [],
      monthdays: [],
    ),
    Task(
      id: '3',
      createdOn: DateTime.now()
          .subtract(const Duration(days: 2)), // Created 2 days ago
      title: 'Make Bed',
      icon: Icons.bed,
      color: Colors.green,
      description: 'Floss in the Morning',
      untilCompleted: false,
      frequencyType: FrequencyType.daily,
      date: getDateNoTimeToday(),
      weekdays: [],
      monthdays: [],
    ),
    Task(
      id: '4',
      createdOn: DateTime.now(),
      title: 'Drink Water',
      icon: Icons.local_drink,
      color: Colors.lightBlue,
      description: 'Floss in the Morning',
      untilCompleted: false,
      frequencyType: FrequencyType.daily,
      date: getDateNoTimeToday(),
      weekdays: [],
      monthdays: [],
    ),
  ],
);
