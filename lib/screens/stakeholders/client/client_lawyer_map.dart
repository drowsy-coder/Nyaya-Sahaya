// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  late String _darkMapStyle;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(13.043554623623109, 80.23367539609262), //T Nagar
    zoom: 11,
  );

  List<String> names = [
    "IFF Law Attorney Law Firm",
    "Advocate Krishna And Associates",
    "Aran Law Firm",
    "S.Maran, Advocate",
    "PRV Law Firm",
    "Advocate J.N.NARESH KUMAR",
    "Shape Legal",
    "Advocate Robin Budhiraja",
    "Advocate Arnab Biswas",
    "Jubina Begum",
    "Advocate Sidhant Singh",
    "JNM Associates",
  ];

  List<String> descriptions = [
    "Consumer Law, Divorce, Trademark, Arbitration etc.",
    "Adoption, Civil Litigation, Family Law, Corporate Law etc.",
    "Criminal Law, Intelectual Property, Landlord/Tenant etc.",
    "Probate, Real Estate, Wills etc.",
    "Sexual Harrasement, Drugs, Personal Defence etc.",
    "Criminal Litigation, Disability Rights, Human Rights etc.",
    " Adoption, Appellate Practice, Arbitration, Banking etc.",
    " Business Litigation, Child Custody, Civil Litigation, Civil Rights etc.",
    " Adoption, Appellate Practice, Arbitration, Mediation, Banking etc.",
    " Criminal, Divorce/Domestic Relations, Family Law, Land Use etc.",
    " Criminal law, Domestic Relations, Drugs, Terrorism Law etc.",
    " Arbitration, Mediation, Banking, Child Custody, Child Support, etc.",
  ];

  List<String> infoImages = [
    'assets/images/iff.png',
    'assets/images/advkrish.jpeg',
    'assets/images/aran.jpeg',
    'assets/images/smaran.jpeg',
    'assets/images/prv.png',
    'assets/images/naresh.jpeg',
    'assets/images/iff.png',
    'assets/images/advkrish.jpeg',
    'assets/images/aran.jpeg',
    'assets/images/smaran.jpeg',
    'assets/images/prv.png',
    'assets/images/naresh.jpeg',
  ];

  List<int> phoneNum = [
    9791175404,
    9442388179,
    4448135125,
    9650587881,
    7972229171,
    9444017750,
    9582948804,
    9780776459,
    9831834759,
    7002487140,
    7783844011,
    9323393300,
  ];

  final List<Marker> _markers = <Marker>[];

  final List<LatLng> _latLang = <LatLng>[
    const LatLng(
        13.066113910331111, 80.27026109848218), //IFF Law Attorney Law Firm
    const LatLng(12.992312950497801,
        80.26065549360344), //Advocate Krishna And Associates
    const LatLng(13.07118701328052, 80.2535685477166), //Aran Law Firm
    const LatLng(13.008854424369252, 80.2511461464315), //S.Maran, Advocate
    const LatLng(12.935979501187928, 80.2344732943938), // PRV Law Firm
    const LatLng(
        13.07144724710327, 80.26503448074426), //Mr.J.N.NARESH KUMAR //Pro Bono
    const LatLng(28.629692294194797, 77.0824938248511), //shape legal
    const LatLng(31.326788753293773, 75.5957976740784), //Advocate Robin
    const LatLng(22.554520036216307, 88.35016110645994), //Advocate Arnab
    const LatLng(26.105578833459877, 91.71980282444129), // Advocate Jubina
    const LatLng(23.440114289675172, 85.42511679098702), //  advocate s singh
    const LatLng(19.058179212109053, 72.8448911928204), // J
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
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return CustomInfoWindow(
                  title: names[i],
                  description: descriptions[i],
                  image: infoImages[i],
                  phoneNum: phoneNum[i],
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
        title: const Text("Nearby Lawyers"),
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
  final int phoneNum;

  const CustomInfoWindow({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.phoneNum,
  }) : super(key: key);

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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(description),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => launch("tel:$phoneNum"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.white, 
                  ),
                  label: const Text(
                    'Call',
                    style: TextStyle(color: Colors.white), 
                  ),
                ),
                const SizedBox(width: 16), 
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white, 
                  ),
                  label: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white), 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
