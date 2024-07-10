import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Date formatter to be used in the app.
final kDateFormatter = DateFormat('E, MMM d');

enum Weekday {
  sun(
    shorthand: 'Sun',
    longhand: 'Sunday',
    weekdayIndex: DateTime.sunday,
    weekdayButtonKey: Key('sundayKey'),
  ),
  mon(
    shorthand: 'Mon',
    longhand: 'Monday',
    weekdayIndex: DateTime.monday,
    weekdayButtonKey: Key('mondayKey'),
  ),
  tue(
    shorthand: 'Tue',
    longhand: 'Tuesday',
    weekdayIndex: DateTime.tuesday,
    weekdayButtonKey: Key('tuesdayKey'),
  ),
  wed(
    shorthand: 'Wed',
    longhand: 'Wednesday',
    weekdayIndex: DateTime.wednesday,
    weekdayButtonKey: Key('wednesdayKey'),
  ),
  thu(
    shorthand: 'Thu',
    longhand: 'Thursday',
    weekdayIndex: DateTime.thursday,
    weekdayButtonKey: Key('thursdayKey'),
  ),
  fri(
    shorthand: 'Fri',
    longhand: 'Friday',
    weekdayIndex: DateTime.friday,
    weekdayButtonKey: Key('fridayKey'),
  ),
  sat(
    shorthand: 'Sat',
    longhand: 'Saturday',
    weekdayIndex: DateTime.saturday,
    weekdayButtonKey: Key('saturdayKey'),
  ),
  day(
    shorthand: 'Day',
    longhand: 'Day',
    weekdayIndex: -1,
    weekdayButtonKey: Key('dayKey'),
  );

  const Weekday({
    required this.shorthand,
    required this.longhand,
    required this.weekdayIndex,
    required this.weekdayButtonKey,
  });

  final String shorthand;
  final String longhand;
  final int weekdayIndex;
  final Key weekdayButtonKey;

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

enum Frequency {
  once(
    shorthand: 'Once',
    longhand: 'Once',
    tabKey: Key('onceTab'),
  ),
  daily(
    shorthand: 'Daily',
    longhand: 'Daily',
    tabKey: Key('dailyTab'),
  ),
  weekly(
    shorthand: 'Weekly',
    longhand: 'Weekly',
    tabKey: Key('weeklyTab'),
  ),
  monthly(
    shorthand: 'Monthly',
    longhand: 'Monthly',
    tabKey: Key('monthlyTab'),
  );

  const Frequency({
    required this.shorthand,
    required this.longhand,
    required this.tabKey,
  });

  final String shorthand;
  final String longhand;
  final Key tabKey;

  Map<String, dynamic> toMap() => {
        'frequency': name,
      };

  static Frequency fromMap(Map<String, dynamic> map) => values.byName(
        map['frequency'],
      );
}

String getTitleDateString(DateTime date) {
  DateTime formattedDate = getDateNoTime(date);
  if (formattedDate == getDateNoTimeToday()) {
    return 'Today';
  } else if (formattedDate == getDateNoTimeTomorrow()) {
    return 'Tomorrow';
  } else if (formattedDate == getDateNoTimeYesterday()) {
    return 'Yesterday';
  } else {
    return kDateFormatter.format(formattedDate);
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
