import 'package:flow/src/common_widgets/responsive_center.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/routines/presentation/routine_screen/routine_form.dart';
import 'package:flow/src/utils/form_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the product page for a given product ID.
class CreateRoutineScreen extends ConsumerWidget {
  const CreateRoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Routine'),
      ),
      body: const CustomScrollView(
        slivers: [
          ResponsiveSliverCenter(
            padding: EdgeInsets.all(Sizes.p16),
            child: RoutineForm(
              mode: FormMode.create,
            ),
          ),
        ],
      ),
    );
  }
}
