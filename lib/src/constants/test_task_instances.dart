import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instances.dart';
import 'package:flow/src/utils/date.dart';

/// Test tasks to be used until a data source is implemented
final kTestTaskInstances = TaskInstances(
  taskInstancesList: [
    TaskInstance(
      id: '1',
      taskId: '1',
      initialDate: getDateNoTimeToday(),
    ),
  ],
);
