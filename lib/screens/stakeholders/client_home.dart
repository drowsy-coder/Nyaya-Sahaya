import 'package:flutter/material.dart';
import 'package:nyaya_sahaya/widgets/buttons/logout_button.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Client Home Page')), body: LogoutButton(),);

  }
}