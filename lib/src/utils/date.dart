import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Weekday {
  sun(
    shorthand: 'Sun',
    longhand: 'Sunday',
    weekdayIndex: DateTime.sunday,
  ),
  mon(
    shorthand: 'Mon',
    longhand: 'Monday',
    weekdayIndex: DateTime.monday,
  ),
  tue(
    shorthand: 'Tue',
    longhand: 'Tuesday',
    weekdayIndex: DateTime.tuesday,
  ),
  wed(
    shorthand: 'Wed',
    longhand: 'Wednesday',
    weekdayIndex: DateTime.wednesday,
  ),
  thu(
    shorthand: 'Thu',
    longhand: 'Thursday',
    weekdayIndex: DateTime.thursday,
  ),
  fri(
    shorthand: 'Fri',
    longhand: 'Friday',
    weekdayIndex: DateTime.friday,
  ),
  sat(
    shorthand: 'Sat',
    longhand: 'Saturday',
    weekdayIndex: DateTime.saturday,
  ),
  day(
    shorthand: 'Day',
    longhand: 'Day',
    weekdayIndex: -1,
  );

  const Weekday({
    required this.shorthand,
    required this.longhand,
    required this.weekdayIndex,
  });

  final String shorthand;
  final String longhand;
  final int weekdayIndex;

  Map<String, dynamic> toMap() => {
        'weekday': name,
      };

  static Weekday fromMap(Map<String, dynamic> map) => values.byName(
        map['weekday'],
      );
}

class Monthday {
  const Monthday({
    required this.weekday,
    required this.ordinal,
  });

  final Weekday weekday;
  final Ordinal ordinal;

  Map<String, dynamic> toMap() {
    return {
      'weekday': weekday.toMap(),
      'monthOrdinal': ordinal.toMap(),
    };
  }

  factory Monthday.fromMap(Map<String, dynamic> map) {
    return Monthday(
      weekday: Weekday.fromMap(map['weekday']),
      ordinal: Ordinal.fromMap(map['monthOrdinal']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Monthday.fromJson(String source) =>
      Monthday.fromMap(json.decode(source));

  @override
  String toString() => 'Monthday(weekday: $weekday, monthOrdinal: $ordinal)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Monthday &&
        other.weekday == weekday &&
        other.ordinal == ordinal;
  }

  @override
  int get hashCode => weekday.hashCode ^ ordinal.hashCode;
}

enum Ordinal {
  first(
    shorthand: '1st',
    longhand: 'First',
    ordinalIndex: 0,
  ),
  second(
    shorthand: '2nd',
    longhand: 'Second',
    ordinalIndex: 1,
  ),
  third(
    shorthand: '3rd',
    longhand: 'Third',
    ordinalIndex: 2,
  ),
  fourth(
    shorthand: '4th',
    longhand: 'Fourth',
    ordinalIndex: 3,
  ),
  fifth(
    shorthand: '5th',
    longhand: 'Fifth',
    ordinalIndex: 4,
  ),
  last(
    shorthand: 'Last',
    longhand: 'Last',
    ordinalIndex: -1,
  );

  const Ordinal({
    required this.shorthand,
    required this.longhand,
    required this.ordinalIndex,
  });

  final String shorthand;
  final String longhand;
  final int ordinalIndex;

  Map<String, dynamic> toMap() => {
        'monthOrdinal': name,
      };

  static Ordinal fromMap(Map<String, dynamic> map) => values.byName(
        map['monthOrdinal'],
      );
}

enum FrequencyType {
  once(
    shorthand: 'Once',
    longhand: 'Once',
  ),
  daily(
    shorthand: 'Daily',
    longhand: 'Daily',
  ),
  weekly(
    shorthand: 'Weekly',
    longhand: 'Weekly',
  ),
  monthly(
    shorthand: 'Monthly',
    longhand: 'Monthly',
  );

  const FrequencyType({
    required this.shorthand,
    required this.longhand,
  });

  final String shorthand;
  final String longhand;

  Map<String, dynamic> toMap() => {
        'frequencyType': name,
      };

  static FrequencyType fromMap(Map<String, dynamic> map) => values.byName(
        map['frequencyType'],
      );
}

String getDisplayDateString(DateTime date) {
  DateTime formattedDate = getDateNoTime(date);
  if (formattedDate == getDateNoTimeToday()) {
    return 'Today';
  } else if (formattedDate == getDateNoTimeTomorrow()) {
    return 'Tomorrow';
  } else if (formattedDate == getDateNoTimeYesterday()) {
    return 'Yesterday';
  } else {
    return DateFormat('E, MMM d').format(formattedDate);
  }
}

DateTime getDateNoTime(DateTime date) {
  return DateTime(
    date.year,
    date.month,
    date.day,
  );
}

String getDateNoTimeAsString(DateTime date) {
  return getDateNoTime(date).toIso8601String();
}

DateTime getDateNoTimeToday() {
  return getDateNoTime(DateTime.now());
}

DateTime getDateNoTimeYesterday() {
  return getDateNoTimeToday().subtract(const Duration(days: 1));
}

DateTime getDateNoTimeTomorrow() {
  return getDateNoTimeToday().add(const Duration(days: 1));
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




// List<String> sortDaysList(List<String> selectedDays) {
//   return selectedDays.toList()
//     ..sort(
//       (a, b) => shorthandWeekdays.indexOf(a).compareTo(
//             shorthandWeekdays.indexOf(b),
//           ),
//     );
// }

// Map<String, bool> sortDaysMap(Map<String, bool> selectedDays) {
//   List<String> sortedKeys = selectedDays.keys.toList()
//     ..sort(
//       (a, b) => shorthandWeekdays.indexOf(a).compareTo(
//             shorthandWeekdays.indexOf(b),
//           ),
//     );

//   return {for (var key in sortedKeys) key: selectedDays[key]!};
// }