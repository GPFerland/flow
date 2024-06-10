// import 'package:flow/src/features/routines/presentation/reorderable_routine_list.dart';
// import 'package:flutter/material.dart';

// class RoutinesScreen extends StatelessWidget {
//   const RoutinesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox(
//       height: double.infinity,
//       width: double.infinity,
//       child: SingleChildScrollView(
//         physics: AlwaysScrollableScrollPhysics(),
//         child: ReorderableRoutineList(),
//       ),
//     );
//   }
// }

import 'package:flow/src/common_widgets/responsive_center.dart';
import 'package:flow/src/constants/app_sizes.dart';
import 'package:flow/src/features/routines/presentation/routines_list_screen/routine_list.dart';
import 'package:flutter/material.dart';

class RoutinesListScreen extends StatelessWidget {
  const RoutinesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Center(
              child: Text('Routines'),
            ),
          ),
          ResponsiveSliverCenter(
            padding: EdgeInsets.all(Sizes.p16),
            child: RoutinesList(),
          ),
        ],
      ),
    );
  }
}
