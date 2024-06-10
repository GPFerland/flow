import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppScreen {
  checkList,
  tasksList,
  routinesList,
}

enum AppScreenWidth {
  small,
  medium,
  large,
}

const smallCutoff = 840;

class ScreenNotifier extends StateNotifier<AppScreen> {
  ScreenNotifier() : super(AppScreen.checkList);

  void setScreen(AppScreen screen) {
    state = screen;
  }
}

final screenProvider = StateNotifierProvider<ScreenNotifier, AppScreen>(
  (ref) => ScreenNotifier(),
);
