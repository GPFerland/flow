import 'package:flow/providers/theme/base_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class ShowCompletedNotifier extends BaseThemeNotifier<bool> {
  ShowCompletedNotifier() : super(true);

  @override
  String get settingKey => 'showCompleted';

  @override
  bool fromFirestore(data) {
    return data;
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {'showCompleted': state};
  }

  Future<void> getShowCompleted() async {
    getSetting();
  }

  void updateShowCompleted(bool newShowCompleted, BuildContext context) async {
    updateSetting(newShowCompleted, context);
  }
}

final showCompletedProvider =
    StateNotifierProvider<ShowCompletedNotifier, bool>(
  (ref) {
    return ShowCompletedNotifier();
  },
);
