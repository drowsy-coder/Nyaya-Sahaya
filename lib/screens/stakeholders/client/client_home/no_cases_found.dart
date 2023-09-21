import 'package:flutter/material.dart';

class NoCasesFoundScreen extends StatelessWidget {
  const NoCasesFoundScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No current cases."),
    );
  }
}
