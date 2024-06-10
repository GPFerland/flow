import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:flutter/material.dart';

/// Test tasks to be used until a data source is implemented
final kTestTasks = [
  Task(
    id: '1',
    createdOn: DateTime.now(),
    title: 'Brush Teeth',
    icon: Icons.abc,
    color: Colors.blue,
    description: 'Brush Teeth in the Morning',
    showUntilCompleted: false,
  ),
  Task(
    id: '2',
    createdOn: DateTime.now(),
    title: 'Floss',
    icon: Icons.abc,
    color: Colors.blue,
    description: 'Floss in the Morning',
    showUntilCompleted: false,
  ),
  Task(
    id: '3',
    createdOn:
        DateTime.now().subtract(const Duration(days: 2)), // Created 2 days ago
    title: 'Make Bed',
    icon: Icons.bed,
    color: Colors.green,
    description: 'Floss in the Morning',
    showUntilCompleted: false,
  ),
  Task(
    id: '4',
    createdOn: DateTime.now(),
    title: 'Drink Water',
    icon: Icons.local_drink,
    color: Colors.lightBlue,
    description: 'Floss in the Morning',
    showUntilCompleted: false,
  ),
  Task(
    id: '5',
    createdOn:
        DateTime.now().add(const Duration(days: 1)), // Created for tomorrow
    title: 'Go for a Walk',
    icon: Icons.directions_walk,
    color: Colors.orange,
    description: 'Floss in the Morning',
    showUntilCompleted: false,
  ),
  Task(
    id: '6',
    createdOn: DateTime.now()
        .subtract(const Duration(hours: 3)), // Created 3 hours ago
    title: 'Read a Book',
    icon: Icons.book,
    color: Colors.purple,
    description: 'Floss in the Morning',
    showUntilCompleted: false,
  ),
  Task(
    id: '7',
    createdOn:
        DateTime.now().add(const Duration(days: 7)), // Created for next week
    title: 'Call Mom',
    icon: Icons.phone,
    color: Colors.pink,
    description: 'Floss in the Morning',
    showUntilCompleted: false,
  ),
  Task(
    id: '8',
    createdOn: DateTime.now(),
    title: 'Meditate',
    icon: Icons.self_improvement,
    color: Colors.teal,
    description: 'Floss in the Morning',
    showUntilCompleted: false,
  ),
  Task(
    id: '9',
    createdOn: DateTime.now()
        .subtract(const Duration(minutes: 15)), // Created 15 mins ago
    title: 'Stretch',
    icon: Icons.accessibility_new,
    color: Colors.amber,
    description: 'Floss in the Morning',
    showUntilCompleted: false,
  ),
  Task(
    id: '10',
    createdOn:
        DateTime.now().add(const Duration(days: 30)), // Created for next month
    title: 'Pay Bills',
    icon: Icons.payments,
    color: Colors.indigo,
    description: 'Floss in the Morning',
    showUntilCompleted: false,
  ),
  Task(
    id: '11',
    createdOn: DateTime.now(),
    title: 'Write in Journal',
    icon: Icons.edit,
    color: Colors.deepPurple,
    description: 'Floss in the Morning',
    showUntilCompleted: false,
  ),
  Task(
    id: '12',
    createdOn:
        DateTime.now().subtract(const Duration(days: 5)), // Created 5 days ago
    title: 'Clean Room',
    icon: Icons.cleaning_services,
    color: Colors.brown,
    description: 'Floss in the Morning',
    showUntilCompleted: false,
  )
];
