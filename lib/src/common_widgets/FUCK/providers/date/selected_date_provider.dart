import 'package:flow/src/utils/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier() : super(getDateNoTime(DateTime.now()));

  void previousDate() {
    state = state.subtract(const Duration(days: 1));
  }

  void nextDate() {
    state = state.add(const Duration(days: 1));
  }

  void selectDate(DateTime date) {
    state = getDateNoTime(date);
  }
}

final dateProvider = StateNotifierProvider<SelectedDateNotifier, DateTime>(
  (ref) => SelectedDateNotifier(),
);
