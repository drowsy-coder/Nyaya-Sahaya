import 'package:flutter/material.dart';

import '../support/case_info_analyser.dart';

class NoCasesFoundScreen extends StatelessWidget {
  const NoCasesFoundScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Case Details'), actions: [
          IconButton(
            icon: const Icon(Icons.question_mark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CaseInfoAnalyzer(),
                ),
              );
            },
          ),
        ]),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
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
        ));
  }
}
