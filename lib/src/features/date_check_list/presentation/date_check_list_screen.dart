import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/features/date_check_list/data/date_repository.dart';
import 'package:flow/src/features/date_check_list/presentation/date_app_bar/date_app_bar.dart';
import 'package:flow/src/features/date_check_list/presentation/date_check_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';

class DateCheckListScreen extends ConsumerStatefulWidget {
  const DateCheckListScreen({
    super.key,
  });

  // Keys for testing using find.byKey()
  static const dateCheckListKey = Key('dateCheckList');

  @override
  ConsumerState<DateCheckListScreen> createState() {
    return _CheckListScreenState();
  }
}

class _CheckListScreenState extends ConsumerState<DateCheckListScreen> {
  //todo - this kinda sucks, need to start at a high number so the user can
  // swipe in either direction "forever"
  int _index = 10000;
  final _pageController = PreloadPageController(
    initialPage: 10000,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateValue = ref.watch(dateStateChangesProvider);

    return AsyncValueWidget<DateTime>(
      value: dateValue,
      data: (date) {
        return Scaffold(
          appBar: const DateAppBar(),
          body: PreloadPageView.builder(
            key: DateCheckListScreen.dateCheckListKey,
            controller: _pageController,
            preloadPagesCount: 1,
            onPageChanged: (index) {
              final newDate = date.add(Duration(days: index - _index));
              ref.read(dateRepositoryProvider).selectDate(newDate);
              _index = index;
            },
            itemBuilder: (context, index) {
              final checkListDate = date.add(Duration(days: index - _index));
              return DateCheckList(date: checkListDate);
            },
          ),
        );
      },
    );
  }
}
