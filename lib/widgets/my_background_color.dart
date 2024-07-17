import 'package:flutter/material.dart';

class MyBackgroundColor extends StatelessWidget {
  final Widget child;
  const MyBackgroundColor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Color.fromARGB(47, 196, 200, 214),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
