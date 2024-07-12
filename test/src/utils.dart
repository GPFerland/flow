import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';

enum SwipeDirection {
  left,
  right,
}

Task createTestTask({String id = '1'}) {
  return Task(
    id: id,
    priority: 1,
    createdOn: getDateNoTimeToday(),
    title: 'Fart',
    icon: Icons.check,
    color: Colors.deepPurple,
    description: 'Fart in the Morning',
    untilCompleted: true,
    frequency: Frequency.once,
    date: getDateNoTimeToday(),
    weekdays: [],
    monthdays: [],
  );
}

TaskInstance createTestTaskInstance({String id = '1'}) {
  return TaskInstance(
    id: id,
    taskId: '1',
    initialDate: getDateNoTimeToday(),
  );
}
