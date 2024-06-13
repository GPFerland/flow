// import 'package:flow/src/features/check_list/data/local/local_check_list_repository.dart';
// import 'package:flow/src/features/check_list/domain/check_list.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sembast/sembast.dart';
// import 'package:sembast/sembast_io.dart';
// import 'package:sembast_web/sembast_web.dart';

// class SembastCheckListRepository implements LocalCheckListRepository {
//   SembastCheckListRepository(this.db);
//   final Database db;
//   final store = StoreRef.main();

//   static Future<Database> createDatabase(String filename) async {
//     if (!kIsWeb) {
//       final appDocDir = await getApplicationDocumentsDirectory();
//       return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
//     } else {
//       return databaseFactoryWeb.openDatabase(filename);
//     }
//   }

//   static Future<SembastCheckListRepository> makeDefault() async {
//     return SembastCheckListRepository(await createDatabase('default.db'));
//   }

//   static const checkListKey = 'checkList';

//   @override
//   Future<CheckList> fetchCheckList() {
//     // TODO: implement fetchCheckList
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> setCheckList(CheckList checkList) {
//     // TODO: implement setCheckList
//     throw UnimplementedError();
//   }

//   @override
//   Stream<CheckList> watchCheckList() {
//     // TODO: implement watchCheckList
//     throw UnimplementedError();
//   }
// }
