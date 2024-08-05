import 'package:flow/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:flow/src/features/tasks/domain/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductionRemoteTasksRepository implements RemoteTasksRepository {
  ProductionRemoteTasksRepository({
    required this.firestore,
  });

  final FirebaseFirestore firestore;

  // * create
  @override
  Future<void> createTask(String uid, Task task) async {
    final ref = _taskRef(uid, task.id);
    return ref.set(task);
  }

  @override
  Future<void> createTasks(String uid, List<Task> tasks) async {
    final batch = firestore.batch();
    for (Task task in tasks) {
      batch.set(_taskRef(uid, task.id), task);
    }
    batch.commit();
  }

  // * read
  @override
  Future<Task?> fetchTask(String uid, String taskId) async {
    final ref = _taskRef(uid, taskId);
    final docSnapshot = await ref.get();
    return docSnapshot.data();
  }

  @override
  Future<List<Task>> fetchTasks(String uid) async {
    final ref = _tasksRef(uid);
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  @override
  Stream<Task?> watchTask(String uid, String taskId) {
    final ref = _taskRef(uid, taskId);
    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  @override
  Stream<List<Task>> watchTasks(String uid) {
    final ref = _tasksRef(uid);
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());
  }

  // * update
  @override
  Future<void> updateTask(String uid, Task task) async {
    final ref = _taskRef(uid, task.id);
    return ref.set(task);
  }

  @override
  Future<void> updateTasks(String uid, List<Task> tasks) async {
    final batch = firestore.batch();
    for (Task task in tasks) {
      batch.set(_taskRef(uid, task.id), task);
    }
    batch.commit();
  }

  // * delete
  @override
  Future<void> deleteTask(String uid, String taskId) async {
    firestore.doc(taskPath(uid, taskId)).delete();
  }

  @override
  Future<void> deleteTasks(String uid, List<String> taskIds) async {
    final batch = firestore.batch();
    for (String taskId in taskIds) {
      batch.delete(_taskRef(uid, taskId));
    }
    batch.commit();
  }

  // * search todo - ?????
  @override
  Query<Task> tasksQuery(String uid) {
    return firestore
        .collection('users/$uid/tasks')
        .withConverter(
          fromFirestore: (snapshot, _) => Task.fromMap(snapshot.data()!),
          toFirestore: (task, _) => task.toMap(),
        )
        .orderBy('priority', descending: false);
  }

  // * helper methods
  static String tasksPath(String uid) => 'users/$uid/tasks';

  static String taskPath(String uid, TaskId taskId) =>
      'users/$uid/tasks/$taskId';

  DocumentReference<Task> _taskRef(String uid, TaskId taskId) {
    return firestore.doc('users/$uid/tasks/$taskId').withConverter(
          fromFirestore: (doc, _) => Task.fromMap(doc.data()!),
          toFirestore: (task, _) => task.toMap(),
        );
  }

  Query<Task> _tasksRef(String uid) {
    return firestore
        .collection('users/$uid/tasks')
        .withConverter(
          fromFirestore: (doc, _) => Task.fromMap(doc.data()!),
          toFirestore: (task, _) => task.toMap(),
        )
        .orderBy('priority');
  }
}
