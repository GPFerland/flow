import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingList extends StatelessWidget {
  const ShimmerLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: ListView.builder(
        itemCount: 12,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
            highlightColor: Theme.of(context)
                .colorScheme
                .onPrimaryContainer
                .withOpacity(0.5),
            child: const Card(
              margin: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.refresh,
                      size: 50,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text('Loading...'),
                    ),
                    Icon(Icons.refresh),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
