import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flow/data/models/base_model.dart';
import 'package:flow/utils/error.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

abstract class BaseModelNotifier<T extends BaseModel>
    extends StateNotifier<List<T>> {
  BaseModelNotifier() : super([]);

  CollectionReference<T> getCollectionRef();

  Future<List<T>> getItems() async {
    List<T> items = [];

    try {
      final itemQuerySnapshots = await getCollectionRef().get();

      items = itemQuerySnapshots.docs.map(
        (QueryDocumentSnapshot<T> docSnapshot) {
          return docSnapshot.data();
        },
      ).toList();
    } catch (error) {
      items = [];
    }

    return items;
  }

  Future<void> createItem(T item, BuildContext context) async {
    item.setPriority(state.length);
    getCollectionRef().add(item).then(
      (documentSnapshot) {
        item.setId(documentSnapshot.id);
        _addItemToState(item);
      },
    ).onError(
      (error, stackTrace) {
        // Consider retry logic or revert state change
        displayErrorMessageInSnackBar(
          context: context,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<void> createItems(List<T> items, BuildContext context) async {
    _addItemsToState(items);

    final WriteBatch createItemsBatch = FirebaseFirestore.instance.batch();
    for (T item in items) {
      createItemsBatch.set(
        getCollectionRef().doc(),
        item,
      );
    }

    createItemsBatch.commit().onError(
      (error, stackTrace) {
        // Consider retry logic or revert state change
        displayErrorMessageInSnackBar(
          context: context,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<void> updateItem(T item, BuildContext context) async {
    _updateItemInState(item);

    getCollectionRef().doc(item.id).update(item.toFirestore()).onError(
      (error, stackTrace) {
        // Consider retry logic or revert state change
        displayErrorMessageInSnackBar(
          context: context,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<void> updateItems(List<T> items, BuildContext context) async {
    _updateItemsInState(items);

    final WriteBatch updateItemsBatch = FirebaseFirestore.instance.batch();
    for (T item in items) {
      updateItemsBatch.update(
        getCollectionRef().doc(item.id),
        item.toFirestore(),
      );
    }

    updateItemsBatch.commit().onError(
      (error, stackTrace) {
        // Consider retry logic or revert state change
        displayErrorMessageInSnackBar(
          context: context,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<void> deleteItem(T item, BuildContext context) async {
    _removeItemFromState(item);

    getCollectionRef().doc(item.id).delete().onError(
      (error, stackTrace) {
        //todo - Consider retry logic and revert state change
        displayErrorMessageInSnackBar(
          context: context,
          errorMessage: error.toString(),
        );
      },
    );
  }

  void _addItemToState(T item) {
    state = [
      ...state,
      item,
    ];
  }

  void _addItemsToState(List<T> items) {
    state = [
      ...state,
      ...items,
    ];
  }

  void _updateItemInState(T updateItem) {
    state = [
      for (final item in state)
        if (updateItem.id == item.id) updateItem else item,
    ];
  }

  //todo - I dont really love this function, could use priority for the index
  // maybe????
  void _updateItemsInState(List<T> updateItems) {
    final List<T> updatedState = [...state];

    for (final T updateItem in updateItems) {
      final index = updatedState.indexWhere((item) => item.id == updateItem.id);
      if (index != -1) {
        updatedState[index] = updateItem;
      } else {
        updatedState.add(updateItem);
      }
    }

    state = updatedState;
  }

  void _removeItemFromState(T removeItem) {
    state = [
      for (final item in state)
        if (removeItem.id != item.id) item,
    ];
  }
}
