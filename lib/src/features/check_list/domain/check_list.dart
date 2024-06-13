import 'package:flow/src/features/task_instances/domain/task_instance.dart';

class CheckList {
  const CheckList({this.taskInstances = const []});

  final List<TaskInstanceId> taskInstances;
}
