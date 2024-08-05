import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter/material.dart';

enum SwipeDirection {
  left,
  right,
}

Task createTestTask({
  String id = '1',
  Frequency frequency = Frequency.once,
}) {
  return Task(
    id: id,
    priority: 0,
    createdOn: getDateNoTimeToday(),
    title: 'Fart',
    icon: Icons.check,
    color: Colors.deepPurple,
    description: 'Fart in the Morning',
    untilAddressed: true,
    frequency: frequency,
    date: getDateNoTimeToday(),
    weekdays: [],
    monthdays: [],
  );
}

TaskInstance createTestTaskInstance({String id = '1'}) {
  return TaskInstance(
    id: id,
    taskId: '1',
    taskPriority: 0,
    untilAddressed: true,
    scheduledDate: getDateNoTimeToday(),
  );
}
