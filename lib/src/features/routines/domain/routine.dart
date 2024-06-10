import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/src/utils/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class Routine extends BaseModel {
  Routine({
    this.title,
    this.icon,
    this.color,
    this.description,
  });

  String? title;
  IconData? icon;
  Color? color;
  String? description;

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
      if (icon != null)
        'icon': serializeIcon(
          icon!,
          iconPack: IconPack.allMaterial,
        ),
      if (color != null) 'color': color!.value,
      if (description != null) 'description': description,
      'priority': priority,
    };
  }
}
