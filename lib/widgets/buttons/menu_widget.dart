import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MenuWidget extends StatelessWidget {
  Widget build(BuildContext context) => IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          ZoomDrawer.of(context)!.toggle();
          print("hel");
        },
      );
}
