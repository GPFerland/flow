import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/models/base_model.dart';
import 'package:flow/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class Routine extends BaseModel {
  Routine({
    this.title,
    this.icon,
    this.color,
    this.description,
    this.tasks,
    this.isExpanded,
  });

  String? title;
  IconData? icon;
  Color? color;
  String? description;
  List<Task>? tasks;
  bool? isExpanded;

  factory Routine.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    Routine routine = Routine(
      title: data?['title'],
      icon: deserializeIcon(data?['icon'], iconPack: IconPack.allMaterial),
      color: Color(data?['color']),
      description: data?['description'],
      tasks: [],
      isExpanded: false,
    );

    //todo - these should probably be setters?????>>>?>>?>??
    routine.setId(snapshot.id);
    routine.setPriority(data?['priority']);

    return routine;
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      if (icon != null) 'icon': serializeIcon(icon!),
      if (color != null) 'color': color!.value,
      if (description != null) 'description': description,
      'priority': priority,
    };
  }

  void addTask(Task task) {
    tasks ??= List<Task>.empty(growable: true);
    if (!tasks!.contains(task)) {
      tasks!.add(task);
    }
  }

  int getHighestTaskPriority(DateTime date) {
    //todo - fuck this number bitch
    int tempPriority = 10000;
    if (tasks != null && tasks!.isNotEmpty) {
      for (Task task in tasks!) {
        tempPriority =
            task.priority! < tempPriority ? task.priority! : tempPriority;
      }
    }
    return tempPriority;
  }

  int getHighestUncompletedTaskPriority(DateTime date) {
    //todo - I dont think this number is good to use
    int tempPriority = 10000;
    if (tasks != null && tasks!.isNotEmpty) {
      for (Task task in tasks!) {
        tempPriority = task.priority! < tempPriority && !task.isComplete(date)
            ? task.priority!
            : tempPriority;
      }
    }
    return tempPriority;
  }

  bool isComplete(DateTime date) {
    bool isComplete = true;
    for (Task task in tasks!) {
      if (!task.isComplete(date)) {
        isComplete = false;
      }
    }
    return isComplete;
  }
}
