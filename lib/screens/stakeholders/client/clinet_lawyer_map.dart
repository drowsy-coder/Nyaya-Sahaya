import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  late String _darkMapStyle;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(12.840738491239273, 80.15339126033456),
    zoom: 14,
  );

  List<String> names = [
    "VIT Health Centre",
    "VIT Health",
    "VIT Centre",
    "VIT",
    "V",
    "Chetti",
  ];

  List<String> descriptions = [
    "Description for Health Centre",
    "Description for VIT Health",
    "Description for VIT Centre",
    "Description for VIT",
    "Description for V",
    "Description for Chetti",
  ];

  List<String> infoImages = [
    'assets/images/lentils.png',
    'assets/images/mental.png',
    'assets/images/ncw.png',
    'assets/images/sfi.png',
    'assets/images/sleep.png',
    'assets/images/logo.png',
  ];

  final List<Marker> _markers = <Marker>[];

  final List<LatLng> _latLang = <LatLng>[
    const LatLng(12.8496091277555, 80.15448915392965),
    const LatLng(12.85007219063799, 80.14166343035889),
    const LatLng(12.902598990948494, 80.15847617410229),
    const LatLng(12.898777606179255, 80.20596499331037),
    const LatLng(12.925420080357393, 80.11420372826137),
    const LatLng(12.795994301253048, 80.21581466700889),
  ];

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    loadData();
  }

  Future<void> _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/json/dark_theme.json');
  }

  void loadData() async {
    for (int i = 0; i < _latLang.length; i++) {
      Uint8List? markerIcon =
          await getBytesFromAssets('assets/images/lawyer.png', 200);

      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _latLang[i],
          icon: BitmapDescriptor.fromBytes(markerIcon!),
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return CustomInfoWindow(
                  title: names[i],
                  description: descriptions[i],
                  image: infoImages[i],
                );
              },
            );
          },
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Hospitals"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            controller.setMapStyle(_darkMapStyle);
          },
          myLocationEnabled: true,
        ),
      ),
    );
  }
}

class CustomInfoWindow extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const CustomInfoWindow({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(description),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              primary: Colors.blue,
            ),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
