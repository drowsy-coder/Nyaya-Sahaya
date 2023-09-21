import 'package:flutter/material.dart';
import 'package:nyaya_sahaya/widgets/buttons/logout_button.dart';

class LawyerReadScreen extends StatelessWidget {
  const LawyerReadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LogoutButton(),
    );
  }
}
