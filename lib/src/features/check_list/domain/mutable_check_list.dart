// import 'package:flow/src/features/check_list/domain/check_list.dart';
// import 'package:flow/src/features/tasks/domain/task.dart';
// import 'package:flow/src/features/task_instances/domain/task_instance.dart';

// /// Helper extension used to mutate the tasks in the check list.
// extension MutableCheckList on CheckList {
//   /// add an taskInstance to the check list
//   CheckList addTaskInstance(TaskInstance taskInstance) {
//     final copy = List<TaskInstanceId>.from(taskInstances);
//     copy.add(taskInstance.id);
//     return CheckList(taskInstances: copy);
//   }

//   /// add a list of tasks to the checkList
//   CheckList addTaskInstances(List<TaskInstance> taskInstancesToAdd) {
//     final copy = List<TaskInstanceId>.from(taskInstances);
//     for (var taskInstance in taskInstancesToAdd) {
//       copy.add(taskInstance.id);
//     }
//     return CheckList(taskInstances: copy);
//   }

//   /// if an taskInstance with the given taskId is found, remove it
//   CheckList removeTaskInstanceById(TaskId taskId) {
//     final copy = List<TaskInstanceId>.from(taskInstances);
//     copy.remove(taskId);
//     return CheckList(taskInstances: copy);
//   }
// }
