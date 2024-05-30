import 'package:flutter/material.dart';

//todo - is there a better way to do this maybe??????
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
          color: Colors.white,
        ),
      ),
    );
  }
}
