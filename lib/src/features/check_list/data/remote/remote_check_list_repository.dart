// import 'package:flow/src/features/check_list/data/remote/test_remote_check_list_repository.dart';
// import 'package:flow/src/features/check_list/domain/check_list.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// /// API for reading, watching and writing checkList data for a specific user ID
// abstract class RemoteCheckListRepository {
//   Future<CheckList> fetchCheckList(String uid);

//   Stream<CheckList> watchCheckList(String uid);

//   Future<void> setCheckList(String uid, CheckList checkList);
// }

// final remoteCheckListRepositoryProvider =
//     Provider<RemoteCheckListRepository>((ref) {
//   // todo - replace with "real" remote checkList repository
//   return TestRemoteCheckListRepository();
// });
