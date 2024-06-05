import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/data/models/occurrence.dart';
import 'package:flow/data/providers/models/base_models_provider.dart';
import 'package:flow/utils/error.dart';
import 'package:flow/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class OccurrencesNotifier extends BaseModelNotifier<Occurrence> {
  OccurrencesNotifier() : super();

  @override
  CollectionReference<Occurrence> getCollectionRef() {
    return getOccurrenceCollectionRef();
  }

  Future<void> getOccurrences() async {
    state = await getItems();
  }

  void createOccurrence(
    Occurrence occurrence,
    BuildContext context,
  ) async {
    createItem(occurrence, context);
  }

  void createOccurrences(
    List<Occurrence> occurrences,
    BuildContext context,
  ) async {
    createItems(occurrences, context);
  }

  void updateOccurrence(
    Occurrence occurrence,
    BuildContext context,
  ) async {
    updateItem(occurrence, context);
  }

  void updateOccurrences(
    List<Occurrence> occurrences,
    BuildContext context,
  ) async {
    updateItems(occurrences, context);
  }

  void deleteOccurrence(
    Occurrence occurrence,
    BuildContext context,
  ) async {
    deleteItem(occurrence, context);
  }

  void deleteTaskOccurrences(String taskId, BuildContext context) async {
    final occurrenceCollectionRef = getOccurrenceCollectionRef();
    final occurrenceBatch = FirebaseFirestore.instance.batch();

    for (Occurrence occurrence in state) {
      if (occurrence.taskId == taskId) {
        final occurrenceDocumentRef =
            occurrenceCollectionRef.doc(occurrence.id);
        occurrenceBatch.delete(occurrenceDocumentRef);
      }
    }

    occurrenceBatch.commit().onError(
      (error, stackTrace) {
        // Consider retry logic or revert state change
        displayErrorMessageInSnackBar(
          context: context,
          errorMessage: error.toString(),
        );
      },
    );
  }
}

final occurrencesProvider =
    StateNotifierProvider<OccurrencesNotifier, List<Occurrence>>(
  (ref) {
    return OccurrencesNotifier();
  },
);
