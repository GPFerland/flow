import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';

final TaskInstances kTestTaskInstances = TaskInstances(
  taskInstancesList: [
    TaskInstance(
      id: '1',
      taskId: '1', // Assuming you have tasks with these IDs
      taskPriority: 1,
      routineId: 'routine1',
      completed: true,
      completedDate: DateTime.now().subtract(const Duration(days: 1)),
      initialDate: DateTime(2024, 6, 11),
    ),
    TaskInstance(
      id: '2',
      taskId: '2',
      taskPriority: 2,
      routineId: null, // An independent task (not part of a routine)
      completed: false,
      initialDate: DateTime.now(),
    ),
    TaskInstance(
      id: '3',
      taskId: '3',
      taskPriority: 3,
      routineId: 'routine2',
      completed: false,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      rescheduledDate:
          DateTime.now().add(const Duration(days: 2)), // Rescheduled for later
    ),
    TaskInstance(
      id: '4',
      taskId: '4',
      taskPriority: 1,
      routineId: 'routine1',
      completed: false,
      skipped: true,
      skippedDate: DateTime.now(),
      initialDate: DateTime.now(),
    ),
    TaskInstance(
      id: '5',
      taskId: '5',
      taskPriority: 2,
      routineId: 'routine2',
      completed: true,
      completedDate: DateTime.now()
          .subtract(const Duration(days: 7)), // Completed last week
      initialDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
    TaskInstance(
      id: '6',
      taskId: '6',
      taskPriority: 3,
      routineId: null,
      completed: true,
      completedDate: DateTime.now()
          .subtract(const Duration(hours: 3)), // Completed 3 hours ago
      initialDate: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    TaskInstance(
      id: '7',
      taskId: '7',
      taskPriority: 1,
      routineId: 'routine3', // Part of a different routine
      completed: false,
      initialDate: DateTime.now()
          .add(const Duration(days: 5)), // Scheduled for 5 days from now
    ),
    TaskInstance(
      id: '8',
      taskId: '8',
      taskPriority: 2,
      routineId: null,
      completed: false,
      initialDate: DateTime.now(),
    ),
    TaskInstance(
      id: '9',
      taskId: '9',
      taskPriority: 3,
      routineId: 'routine1',
      completed: false,
      initialDate: DateTime.now()
          .add(const Duration(days: 3)), // Scheduled for 3 days from now
    ),
    TaskInstance(
      id: '10',
      taskId: '10',
      taskPriority: 1,
      routineId: 'routine2',
      completed: false,
      initialDate: DateTime.now(),
    ),
  ],
);
