import 'package:flow/src/features/date_check_list/data/date_repository.dart';
import 'package:flow/src/utils/date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DateRepository makeDateRepository() => DateRepository();
  group('DateRepository', () {
    test('date is today with no time', () {
      final dateRepository = makeDateRepository();
      addTearDown(dateRepository.dispose);
      expect(dateRepository.date, getDateNoTimeToday());
      expect(dateRepository.dateStateChanges(), emits(getDateNoTimeToday()));
    });

    test('date is today then changes to tomorrow', () async {
      final dateRepository = makeDateRepository();
      addTearDown(dateRepository.dispose);
      expect(dateRepository.date, getDateNoTimeToday());
      expect(dateRepository.dateStateChanges(), emits(getDateNoTimeToday()));
      await dateRepository.selectDate(getDateNoTimeTomorrow());
      expect(dateRepository.date, getDateNoTimeTomorrow());
      expect(dateRepository.dateStateChanges(), emits(getDateNoTimeTomorrow()));
    });
  });
}
