import 'package:flow/src/common_widgets/async_value_widget.dart';
import 'package:flow/src/features/check_list/data/date_repository.dart';
import 'package:flow/src/features/check_list/presentation/app_bar/check_list_app_bar.dart';
import 'package:flow/src/features/check_list/presentation/check_list/check_list.dart';
import 'package:flow/src/features/check_list/presentation/check_list_controller.dart';
import 'package:flow/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';

class CheckListScreen extends ConsumerStatefulWidget {
  const CheckListScreen({
    super.key,
  });

  // Keys for testing using find.byKey()
  static const dateCheckListKey = Key('dateCheckList');

  @override
  ConsumerState<CheckListScreen> createState() {
    return _CheckListScreenState();
  }
}

class _CheckListScreenState extends ConsumerState<CheckListScreen> {
  late int _pageControllerIndex;
  late PreloadPageController _pageController;

  @override
  void initState() {
    super.initState();
    //todo - this kinda sucks, need to start at a high number so the user can
    // swipe in either direction "forever"
    _pageControllerIndex = 10000;
    _pageController = PreloadPageController(
      initialPage: _pageControllerIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      checkListControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    return Scaffold(
      appBar: const CheckListAppBar(),
      body: PreloadPageView.builder(
        key: CheckListScreen.dateCheckListKey,
        controller: _pageController,
        preloadPagesCount: 1,
        onPageChanged: (index) {
          if (index - _pageControllerIndex == 1) {
            ref.read(dateRepositoryProvider).selectTomorrow();
          } else if (index - _pageControllerIndex == -1) {
            ref.read(dateRepositoryProvider).selectYesterday();
          }
          _pageControllerIndex = index;
        },
        itemBuilder: (context, index) {
          return Consumer(builder: (context, ref, child) {
            final dateValue = ref.watch(dateStreamProvider);
            return AsyncValueWidget<DateTime>(
              value: dateValue,
              data: (date) {
                final checkListDate = date.add(
                  Duration(days: index - _pageControllerIndex),
                );
                return CheckList(date: checkListDate);
              },
            );
          });
        },
      ),
    );
  }
}
