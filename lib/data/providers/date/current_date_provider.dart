import 'dart:async';

import 'package:flow/utils/date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentDateNotifier extends StateNotifier<DateTime> {
  CurrentDateNotifier() : super(DateTime.now()) {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state != getDateNoTimeToday()) {
          state = getDateNoTimeToday();
        }
      },
    );
  }

  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

final currentDateProvider =
    StateNotifierProvider<CurrentDateNotifier, DateTime>(
        (ref) => CurrentDateNotifier());
