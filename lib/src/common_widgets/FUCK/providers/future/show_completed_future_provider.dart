import 'package:flow/src/common_widgets/FUCK/providers/theme/show_completed_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showCompletedFutureProvider = FutureProvider<void>((ref) async {
  await ref.read(showCompletedProvider.notifier).getShowCompleted();
});
