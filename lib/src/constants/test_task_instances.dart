import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flow/src/utils/date.dart';

/// Test task instances to be used until a data source is implemented
final kTestTaskInstances = TaskInstances(
  taskInstancesList: [
    TaskInstance(
      id: '1',
      taskId: '1',
      initialDate: getDateNoTimeToday(),
    ),
    TaskInstance(
      id: '2',
      taskId: '2',
      initialDate: getDateNoTimeToday(),
    ),
    TaskInstance(
      id: '3',
      taskId: '3',
      initialDate: getDateNoTimeToday(),
    ),
    TaskInstance(
      id: '4',
      taskId: '4',
      initialDate: getDateNoTimeToday(),
    ),
  ],
);
