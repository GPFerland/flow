// import 'package:flow/src/features/check_list/data/local/local_check_list_repository.dart';
// import 'package:flow/src/features/check_list/domain/check_list.dart';
// import 'package:flow/src/utils/delay.dart';
// import 'package:flow/src/utils/in_memory_store.dart';

// class TestLocalCheckListRepository implements LocalCheckListRepository {
//   TestLocalCheckListRepository({this.addDelay = true});
//   final bool addDelay;

//   final _checkList = InMemoryStore<CheckList>(const CheckList());

//   @override
//   Future<CheckList> fetchCheckList() => Future.value(_checkList.value);

//   @override
//   Stream<CheckList> watchCheckList() => _checkList.stream;

//   @override
//   Future<void> setCheckList(CheckList checkList) async {
//     await delay(addDelay);
//     _checkList.value = checkList;
//   }
// }
