import 'package:flow/providers/theme/base_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class ColorNotifier extends BaseThemeNotifier<Color> {
  ColorNotifier() : super(Colors.blue);

  @override
  String get settingKey => 'color';

  @override
  Color fromFirestore(data) {
    return Color(data);
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {'color': state.value};
  }

  Future<void> getColor() async {
    getSetting();
  }

  void updateColor(Color newColor, BuildContext context) async {
    updateSetting(newColor, context);
  }
}

final colorProvider = StateNotifierProvider<ColorNotifier, Color>(
  (ref) {
    return ColorNotifier();
  },
);
