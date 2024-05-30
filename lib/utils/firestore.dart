import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/models/occurrence.dart';
import 'package:flow/models/routine.dart';
import 'package:flow/models/task.dart';

final _firebaseAuth = FirebaseAuth.instance;

Future<String?> logInUser({
  required String email,
  required String password,
}) async {
  String? errorMsg;
  try {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (error) {
    if (error.code == 'invalid-email') {
      errorMsg = 'Please enter a valid email address. e.g. name@service.com';
    } else if (error.code == 'user-disabled') {
      errorMsg = 'Account associated with $email is disabled.';
    } else if (error.code == 'user-not-found') {
      errorMsg = '$email is not associated with an account. Sign up?';
    } else if (error.code == 'wrong-password') {
      errorMsg = 'Password is incorret.';
    } else if (error.code == 'invalid-credential') {
      errorMsg = 'Email or password is incorrect.';
    } else if (error.code == 'too-many-requests') {
      errorMsg = 'Too many requests, please try again later.';
    } else {
      errorMsg = 'Failed to login.';
    }
  }
  return errorMsg;
}

Future<String?> signUpUser({
  required String username,
  required String email,
  required String password,
}) async {
  UserCredential? userCredentials;
  String? errorMsg;
  try {
    userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredentials.user!.uid)
        .set(
      {
        'username': username,
        'email': email,
      },
    );
    await FirebaseFirestore.instance
        .collection('daily_lists')
        .doc(userCredentials.user!.uid)
        .set(
      {
        'daily_lists': [],
      },
    );
    await FirebaseFirestore.instance
        .collection('routines')
        .doc(userCredentials.user!.uid)
        .set(
      {
        'routines': [],
      },
    );
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(userCredentials.user!.uid)
        .set(
      {
        'tasks': [],
      },
    );
  } on FirebaseAuthException catch (error) {
    if (error.code == 'email-already-in-use') {
      errorMsg = '$email is already associated with an account. Log in?';
    } else if (error.code == 'invalid-email') {
      errorMsg = 'Please enter a valid email address. e.g. name@service.com';
    } else if (error.code == 'weak-password') {
      errorMsg = error.message!;
    } else if (error.code == 'too-many-requests') {
      errorMsg = 'Too many requests, please try again later.';
    } else {
      errorMsg = 'Failed to create an account for $email.';
    }
  }
  return errorMsg;
}

void logOutUser() {
  FirebaseAuth.instance.signOut();
}

User? getUser() {
  User? user = FirebaseAuth.instance.currentUser;
  return user;
}

String? getUserEmail() {
  final User? user = getUser();
  if (user != null) {
    return user.email;
  }
  return null;
}

CollectionReference<Routine> getRoutineCollectionRef() {
  final User user = getUser()!;

  final routineCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('routines')
      .withConverter(
          fromFirestore: Routine.fromFirestore,
          toFirestore: (Routine routine, options) {
            return routine.toFirestore();
          });
  return routineCollectionRef;
}

CollectionReference<Map<String, dynamic>> getThemeCollectionRef() {
  final User user = getUser()!;

  final themeCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('theme');
  return themeCollectionRef;
}

CollectionReference<Task> getTaskCollectionRef() {
  final User user = getUser()!;

  final taskCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('tasks')
      .withConverter(
          fromFirestore: Task.fromFirestore,
          toFirestore: (Task task, options) {
            return task.toFirestore();
          });
  return taskCollectionRef;
}

CollectionReference<Occurrence> getOccurrenceCollectionRef() {
  final User user = getUser()!;

  final occurrenceCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('occurrences')
      .withConverter(
          fromFirestore: Occurrence.fromFirestore,
          toFirestore: (Occurrence occurrence, options) {
            return occurrence.toFirestore();
          });
  return occurrenceCollectionRef;
}
