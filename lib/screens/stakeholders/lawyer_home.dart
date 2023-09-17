import 'package:flutter/material.dart';

import '../../widgets/buttons/logout_button.dart';

class LawyerHomePage extends StatelessWidget {
  const LawyerHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: const Text('Lawyer Home Page')),
        body: LogoutButton(),
      ),
    );
  }
}
