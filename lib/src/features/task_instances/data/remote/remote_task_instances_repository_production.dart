import 'package:collection/collection.dart';
import 'package:flow/src/features/task_instances/data/remote/remote_task_instances_repository.dart';
import 'package:flow/src/features/task_instances/domain/mutable_task_instance.dart';
import 'package:flow/src/features/task_instances/domain/task_instance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductionRemoteTaskInstancesRepository
    implements RemoteTaskInstancesRepository {
  ProductionRemoteTaskInstancesRepository({
    required this.firestore,
  });

  final FirebaseFirestore firestore;

  // * create
  @override
  Future<void> createTaskInstance(String uid, TaskInstance taskInstance) async {
    firestore.doc('users/$uid/taskInstances/${taskInstance.id}').set(
          taskInstance.toMap(),
        );
  }

  @override
  Future<void> createTaskInstances(
    String uid,
    List<TaskInstance> taskInstances,
  ) async {
    final batch = firestore.batch();
    for (TaskInstance taskInstance in taskInstances) {
      //todo - is this an okay way to use the task.id or should I leave it empty to auto generate??????
      // I am already using uuid.v4 to generate the id so its probably fine???
      batch.set(
        firestore.doc('users/$uid/taskInstances/${taskInstance.id}'),
        taskInstance.toMap(),
      );
    }
    batch.commit();
  }

  // * read
  @override
  Future<TaskInstance?> fetchTaskInstance(
    String uid,
    String taskInstanceId,
  ) async {
    final userTaskInstances = await fetchTaskInstances(uid);
    return Future.value(
      userTaskInstances.firstWhereOrNull(
        (taskInstance) => taskInstance.id == taskInstanceId,
      ),
    );
  }

  @override
  Future<List<TaskInstance>> fetchTaskInstances(String uid) async {
    final taskInstancesSnapshot =
        firestore.collection('users/$uid/taskInstances').get().then(
      (querySnapshot) {
        List<TaskInstance> taskInstances = List.empty(growable: true);
        for (final docSnapshot in querySnapshot.docs) {
          taskInstances.add(TaskInstance.fromMap(docSnapshot.data()));
        }
        return taskInstances;
      },
    );
    return taskInstancesSnapshot;
  }

  @override
  Stream<TaskInstance?> watchTaskInstance(
    String uid,
    String taskInstanceId,
  ) {
    return watchTaskInstances(uid, null).map(
      (taskInstances) => taskInstances.firstWhereOrNull(
        (taskInstance) => taskInstance.id == taskInstanceId,
      ),
    );
  }

  @override
  Stream<List<TaskInstance>> watchTaskInstances(String uid, DateTime? date) {
    final taskInstancesStream = firestore
        .collection('users/$uid/taskInstances')
        .snapshots()
        .map((querySnap) => querySnap.docs
            .map((taskInstance) => TaskInstance.fromMap(taskInstance.data()))
            .toList());
    if (date != null) {
      return taskInstancesStream.map((taskInstances) => taskInstances
          .where(
            (taskInstance) => taskInstance.isDisplayed(date),
          )
          .toList());
    }
    return taskInstancesStream;
  }

  // * update
  @override
  Future<void> updateTaskInstance(String uid, TaskInstance taskInstance) async {
    firestore
        .doc('users/$uid/taskInstances/${taskInstance.id}')
        .update(taskInstance.toMap());
  }

  @override
  Future<void> updateTaskInstances(
      String uid, List<TaskInstance> taskInstances) {
    // todo: implement updateTaskInstances
    throw UnimplementedError();
  }

  // * delete
  @override
  Future<void> deleteTaskInstance(String uid, String taskInstanceId) async {
    firestore.doc('users/$uid/taskInstances/$taskInstanceId').delete();
  }

  @override
  Future<void> deleteTaskInstances(String uid, List<String> taskInstanceIds) {
    // todo: implement deleteTaskInstances
    throw UnimplementedError();
  }

  // * search todo - ?????
  @override
  Query<TaskInstance> taskInstancesQuery(String uid) {
    return firestore
        .collection('users/$uid/taskInstances')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              TaskInstance.fromMap(snapshot.data()!),
          toFirestore: (taskInstance, _) => taskInstance.toMap(),
        )
        .orderBy('priority', descending: false);
  }
}
