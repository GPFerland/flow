import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const List<String> shorthandWeekdays = [
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];

enum Frequency {
  once,
  weekly,
  monthly,
}

const Map<Frequency, String> frequencyMap = {
  Frequency.once: 'once',
  Frequency.weekly: 'weekly',
  Frequency.monthly: 'monthly',
};

const Map<String, Frequency> reverseFrequencyMap = {
  'once': Frequency.once,
  'weekly': Frequency.weekly,
  'monthly': Frequency.monthly,
};

enum MonthlyOrdinals {
  first,
  second,
  third,
  fourth,
  last,
}

const Map<MonthlyOrdinals, String> monthlyOrdinalsMap = {
  MonthlyOrdinals.first: 'First',
  MonthlyOrdinals.second: 'Second',
  MonthlyOrdinals.third: 'Third',
  MonthlyOrdinals.fourth: 'Fourth',
  MonthlyOrdinals.last: 'Last',
};

const Map<String, MonthlyOrdinals> reverseMonthlyOrdinalsMap = {
  'First': MonthlyOrdinals.first,
  'Second': MonthlyOrdinals.second,
  'Third': MonthlyOrdinals.third,
  'Fourth': MonthlyOrdinals.fourth,
  'Last': MonthlyOrdinals.last,
};

const Map<String, int> monthlyOrdinalsToIntsMap = {
  'First': 0,
  'Second': 1,
  'Third': 2,
  'Fourth': 3,
  'Last': -1,
};

enum MonthlyWeekdays {
  sun,
  mon,
  tue,
  wed,
  thu,
  fri,
  sat,
  day,
}

const Map<MonthlyWeekdays, String> monthlyWeekdaysMap = {
  MonthlyWeekdays.sun: 'Sunday',
  MonthlyWeekdays.mon: 'Monday',
  MonthlyWeekdays.tue: 'Tuesday',
  MonthlyWeekdays.wed: 'Wednesday',
  MonthlyWeekdays.thu: 'Thursday',
  MonthlyWeekdays.fri: 'Friday',
  MonthlyWeekdays.sat: 'Saturday',
  MonthlyWeekdays.day: 'Day',
};

Map<String, int> weekdayIndices = {
  'Sunday': DateTime.sunday,
  'Monday': DateTime.monday,
  'Tuesday': DateTime.tuesday,
  'Wednesday': DateTime.wednesday,
  'Thursday': DateTime.thursday,
  'Friday': DateTime.friday,
  'Saturday': DateTime.saturday,
};

Map<String, int> shorthandWeekdayIndices = {
  'Sun': DateTime.sunday,
  'Mon': DateTime.monday,
  'Tue': DateTime.tuesday,
  'Wed': DateTime.wednesday,
  'Thu': DateTime.thursday,
  'Fri': DateTime.friday,
  'Sat': DateTime.saturday,
};

List<String> sortDaysList(List<String> selectedDays) {
  return selectedDays.toList()
    ..sort(
      (a, b) => shorthandWeekdays.indexOf(a).compareTo(
            shorthandWeekdays.indexOf(b),
          ),
    );
}

Map<String, bool> sortDaysMap(Map<String, bool> selectedDays) {
  List<String> sortedKeys = selectedDays.keys.toList()
    ..sort(
      (a, b) => shorthandWeekdays.indexOf(a).compareTo(
            shorthandWeekdays.indexOf(b),
          ),
    );

  return {for (var key in sortedKeys) key: selectedDays[key]!};
}

String getFormattedDateString(DateTime date) {
  if (date == getDateNoTimeToday()) {
    return 'Today';
  } else if (date == getDateNoTimeTomorrow()) {
    return 'Tomorrow';
  } else if (date == getDateNoTimeYesterday()) {
    return 'Yesterday';
  } else {
    return DateFormat('E, MMM d, y').format(date);
  }
}

String getAbbreviatedWeekday(DateTime date) {
  return DateFormat('EEE').format(date);
}

DateTime getDateNoTime(DateTime date) {
  DateTime formattedDate = DateTime(
    date.year,
    date.month,
    date.day,
  );
  return formattedDate;
}

DateTime getDateNoTimeToday() {
  DateTime date = DateTime.now();
  DateTime formattedDate = DateTime(
    date.year,
    date.month,
    date.day,
  );
  return formattedDate;
}

DateTime getDateNoTimeYesterday() {
  DateTime date = DateTime.now().subtract(const Duration(days: 1));
  DateTime formattedDate = DateTime(
    date.year,
    date.month,
    date.day,
  );
  return formattedDate;
}

DateTime getDateNoTimeTomorrow() {
  DateTime date = DateTime.now().add(const Duration(days: 1));
  DateTime formattedDate = DateTime(
    date.year,
    date.month,
    date.day,
  );
  return formattedDate;
}

String getDateNoTimeAsString(DateTime date) {
  String formattedDate = DateTime(
    date.year,
    date.month,
    date.day,
  ).toIso8601String();
  return formattedDate;
}

Future<DateTime?> selectDate({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  DateTime today = DateTime.now();

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate ?? today.subtract(const Duration(days: 31)),
    lastDate: lastDate ?? today.add(const Duration(days: 365 * 100)),
  );

  if (picked != null && picked != initialDate) {
    return picked;
  }

  return null;
}
