import 'package:flutter/material.dart';

class NoCasesFoundScreen extends StatelessWidget {
  const NoCasesFoundScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No current cases."),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
