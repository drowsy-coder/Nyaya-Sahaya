import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(28.6139, 77.2090), // New Delhi's coordinates
    zoom: 11,
  );

  final List<Marker> _markers = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(28.6139, 77.2090), // New Delhi's coordinates
    ),
    const Marker(
      markerId: MarkerId('2'),
      position: LatLng(28.6239, 77.2090), // New Delhi's coordinates
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Lawyer'),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
      ),
    );
  }
}
