import 'package:flow/src/utils/error.dart';
import 'package:flow/src/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

abstract class BaseThemeNotifier<T> extends StateNotifier<T> {
  BaseThemeNotifier(super.initialValue);

  String get settingKey;

  T fromFirestore(dynamic data);

  Map<String, dynamic> toFirestore();

  Future<void> getSetting() async {
    try {
      final themeCollectionRef = getThemeCollectionRef();
      final themeQuerySnapshots = await themeCollectionRef.get();

      final settingData = themeQuerySnapshots.docs
          .firstWhere((themeData) => themeData.data().containsKey(settingKey))
          .data();

      final newValue = fromFirestore(settingData[settingKey]);

      if (state != newValue) {
        state = newValue;
      }
    } catch (error) {
      //todo - Handle errors or defaults
    }
  }

  void updateSetting(T newValue, BuildContext context) async {
    if (state == newValue) {
      return;
    }

    state = newValue;

    await getThemeCollectionRef().doc(settingKey).set(toFirestore()).onError(
      (error, stackTrace) {
        //todo - attempt a retry, maybe do this from the snack bar message
        //todo - make sure this error message makes any sense
        displayErrorMessageInSnackBar(
          context: context,
          errorMessage: error.toString(),
        );
      },
    );
  }
}
