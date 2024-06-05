import 'package:flow/data/providers/date/selected_date_provider.dart';
import 'package:flow/data/providers/screen/screen_provider.dart';
import 'package:flow/features/selected_date_list/widgets/selected_date_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';

class SwipeableListScreen extends ConsumerStatefulWidget {
  const SwipeableListScreen({
    super.key,
    required this.width,
  });

  final AppScreenWidth width;

  @override
  ConsumerState<SwipeableListScreen> createState() {
    return _SwipeableListScreenState();
  }
}

class _SwipeableListScreenState extends ConsumerState<SwipeableListScreen> {
  int _currentPage = 10000;

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);

    return PreloadPageView.builder(
      controller: PreloadPageController(initialPage: _currentPage),
      preloadPagesCount: 1,
      onPageChanged: (index) {
        if (index < _currentPage) {
          ref.read(selectedDateProvider.notifier).selectPreviousDay();
        } else if (index > _currentPage) {
          ref.read(selectedDateProvider.notifier).selectNextDay();
        }
        _currentPage = index;
      },
      itemBuilder: (context, index) {
        final pageDate = selectedDate.add(Duration(days: index - _currentPage));
        return SelectedDateList(
          selectedDate: pageDate,
          width: widget.width,
        );
      },
    );
  }

  // final PageController _pageController = PageController(initialPage: 1);
  // bool isListening = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _pageController.addListener(_onPageChanged);
  // }

  // @override
  // void dispose() {
  //   //_pageController.removeListener(_onPageChanged);
  //   _pageController.dispose();
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   DateTime selectedDate = ref.watch(selectedDateProvider);

  //   final previousDatePage = SelectedDateList(
  //     selectedDate: selectedDate.subtract(
  //       const Duration(days: 1),
  //     ),
  //     width: widget.width,
  //   );
  //   final selectedDatePage = SelectedDateList(
  //     width: widget.width,
  //     selectedDate: selectedDate,
  //   );
  //   final nextDatePage = SelectedDateList(
  //     selectedDate: selectedDate.add(
  //       const Duration(
  //         days: 1,
  //       ),
  //     ),
  //     width: widget.width,
  //   );

  //   if (isListening) {
  //     ref.listen(selectedDateProvider, (_, nextDate) {
  //       // Update the PageController's page index when selectedDate changes
  //       _pageController.jumpToPage(1); // Always jump to the middle page
  //       isListening = false;
  //     });
  //   }

  //   return PageView(
  //     controller: _pageController,
  //     onPageChanged: (value) {
  //       isListening = true;
  //       if (value > 1) {
  //         ref.read(selectedDateProvider.notifier).selectNextDay();
  //       } else if (value < 1) {
  //         ref.read(selectedDateProvider.notifier).selectPreviousDay();
  //       }
  //     },
  //     children: [
  //       previousDatePage,
  //       selectedDatePage,
  //       nextDatePage,
  //     ],
  //   );
  // }
}
