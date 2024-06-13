// import 'package:flow/src/features/check_list/data/remote/remote_check_list_repository.dart';
// import 'package:flow/src/features/check_list/domain/check_list.dart';
// import 'package:flow/src/utils/delay.dart';
// import 'package:flow/src/utils/in_memory_store.dart';

// class TestRemoteCheckListRepository implements RemoteCheckListRepository {
//   TestRemoteCheckListRepository({this.addDelay = true});
//   final bool addDelay;

//   /// An InMemoryStore containing the checkList data for all users, where:
//   /// key: uid of the user
//   /// value: CheckList of that user
//   final _checkLists = InMemoryStore<Map<String, CheckList>>({});

//   @override
//   Future<CheckList> fetchCheckList(String uid) {
//     return Future.value(_checkLists.value[uid] ?? const CheckList());
//   }

//   @override
//   Stream<CheckList> watchCheckList(String uid) {
//     return _checkLists.stream
//         .map((checkListData) => checkListData[uid] ?? const CheckList());
//   }

//   @override
//   Future<void> setCheckList(String uid, CheckList checkList) async {
//     await delay(addDelay);
//     // First, get the current checkLists data for all users
//     final checkLists = _checkLists.value;
//     // Then, set the checkList for the given uid
//     checkLists[uid] = checkList;
//     // Finally, update the checkLists data (will emit a new value)
//     _checkLists.value = checkLists;
//   }
// }
