import 'package:flow/src/utils/date.dart';
import 'package:flow/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateRepository {
  DateRepository();

  final _dateState = InMemoryStore<DateTime>(getDateNoTimeToday());

  Stream<DateTime> dateStateChanges() => _dateState.stream;
  DateTime get date => _dateState.value;
  DateTime get dateBefore => _dateState.value.subtract(const Duration(days: 1));
  DateTime get dateAfter => _dateState.value.add(const Duration(days: 1));

  void _selectDate(DateTime date) {
    _dateState.value = getDateNoTime(date);
  }

  Future<void> selectDate(DateTime date) async {
    _selectDate(date);
  }

  Future<void> selectYesterday() async {
    _selectDate(_dateState.value.subtract(const Duration(days: 1)));
  }

  Future<void> selectTomorrow() async {
    _selectDate(_dateState.value.add(const Duration(days: 1)));
  }

  void dispose() => _dateState.close();
}

final dateRepositoryProvider = Provider<DateRepository>(
  (ref) {
    final dateRepository = DateRepository();
    ref.onDispose(() => dateRepository.dispose());
    return dateRepository;
  },
);

final dateStateChangesProvider = StreamProvider<DateTime>(
  (ref) {
    final dateRepository = ref.watch(dateRepositoryProvider);
    return dateRepository.dateStateChanges();
  },
);
