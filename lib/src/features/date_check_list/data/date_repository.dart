import 'package:flow/src/utils/date.dart';
import 'package:flow/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateRepository {
  DateRepository();

  final _dateState = InMemoryStore<DateTime>(getDateNoTimeToday());

  Stream<DateTime> dateStateChanges() => _dateState.stream;
  DateTime get date => _dateState.value;

  Future<void> selectDate(DateTime date) async {
    _selectDate(date);
  }

  void dispose() => _dateState.close();

  void _selectDate(DateTime date) {
    _dateState.value = getDateNoTime(date);
  }
}

final dateRepositoryProvider = Provider<DateRepository>((ref) {
  final dateRepository = DateRepository();
  ref.onDispose(() => dateRepository.dispose());
  return dateRepository;
});

final dateStateChangesProvider = StreamProvider<DateTime>((ref) {
  final dateRepository = ref.watch(dateRepositoryProvider);
  return dateRepository.dateStateChanges();
});
