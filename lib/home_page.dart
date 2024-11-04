import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [Text('is logged in')],
      ),
    );
  }
}
