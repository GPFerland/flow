import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.red,
          ),
    );
  }
}
