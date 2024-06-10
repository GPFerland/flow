import 'package:flow/src/common_widgets/FUCK/providers/date/selected_date_provider.dart';
import 'package:flow/src/common_widgets/FUCK/providers/future/task_and_routine_instance_future_provider.dart';
import 'package:flow/src/common_widgets/FUCK/providers/screen/screen_provider.dart';
import 'package:flow/src/features/check_list/presentation/shimmer_loading_list.dart';
import 'package:flow/src/features/check_list/presentation/check_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';

class CheckListScreen extends ConsumerStatefulWidget {
  const CheckListScreen({
    super.key,
    required this.width,
  });

  final AppScreenWidth width;

  @override
  ConsumerState<CheckListScreen> createState() {
    return _CheckListScreenState();
  }
}

class _CheckListScreenState extends ConsumerState<CheckListScreen> {
  //todo - this kinda sucks, need to start at a high number so the user can
  // swipe in either direction "forever"
  int _currentIndex = 10000;
  final _pageController = PreloadPageController(
    initialPage: 10000,
  );

  // Variables to track loaded dates
  final Set<DateTime> _loadedDates = {};

  @override
  void initState() {
    super.initState();
    _markInitialPagesLoaded();
  }

  void _markInitialPagesLoaded() {
    final currentDate = ref.read(dateProvider);
    for (int i = -1; i <= 1; i++) {
      final date = currentDate.add(Duration(days: i));
      _loadedDates.add(date);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPage(DateTime pageDate) {
    return ref.watch(taskAndRoutineInstanceFutureProvider(pageDate)).when(
      loading: () {
        return const ShimmerLoadingList();
      },
      data: (data) {
        return CheckListScreen(
          key: ValueKey(pageDate.toIso8601String()),
          date: pageDate,
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return Center(
          child: Text(error.toString()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = ref.watch(dateProvider);

    return PreloadPageView.builder(
      controller: _pageController,
      preloadPagesCount: 1,
      onPageChanged: (index) {
        final newDate = currentDate.add(Duration(days: index - _currentIndex));
        for (int i = -1; i <= 1; i++) {
          final date = newDate.add(Duration(days: i));
          if (!_loadedDates.contains(date)) {
            _loadedDates.add(date);
            ref.read(taskAndRoutineInstanceFutureProvider(date).future);
          }
        }
        _currentIndex = index;
        ref.read(dateProvider.notifier).selectDate(newDate);
      },
      itemBuilder: (context, index) {
        final pageDate = currentDate.add(
          Duration(days: index - _currentIndex),
        );
        return _buildPage(pageDate);
      },
    );
  }
}
