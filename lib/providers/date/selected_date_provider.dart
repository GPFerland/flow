import 'package:flow/utils/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier() : super(getDateNoTime(DateTime.now()));

  void selectPreviousDay() {
    state = state.subtract(const Duration(days: 1));
  }

  void selectNextDay() {
    state = state.add(const Duration(days: 1));
  }

  void selectDate(DateTime date) {
    state = getDateNoTime(date);
  }
}

final selectedDateProvider =
    StateNotifierProvider<SelectedDateNotifier, DateTime>(
  (ref) => SelectedDateNotifier(),
);
