import 'package:flow/data/providers/theme/base_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class DarkModeNotifier extends BaseThemeNotifier<bool> {
  DarkModeNotifier() : super(false);

  @override
  String get settingKey => 'darkMode';

  @override
  bool fromFirestore(data) {
    return data;
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {'darkMode': state};
  }

  Future<void> getDarkMode() async {
    getSetting();
  }

  void updateDarkMode(bool newDarkMode, BuildContext context) async {
    updateSetting(newDarkMode, context);
  }
}

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref) {
    return DarkModeNotifier();
  },
);
