import 'dart:async';
import 'dart:typed_data';
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
  ];

  List<String> descriptions = [
    "Consumer Law, Divorce, Trademark, Arbitration etc.",
    "Adoption, Civil Litigation, Family Law, Corporate Law etc.",
    "Criminal Law, Intelectual Property, Landlord/Tenant etc.",
    "Probate, Real Estate, Wills etc.",
    "Sexual Harrasement, Drugs, Personal Defence etc.",
    "Criminal Litigation, Disability Rights, Human Rights etc.",
  ];

  List<String> infoImages = [
    'assets/images/iff.png',
    'assets/images/advkrish.jpeg',
    'assets/images/aran.jpeg',
    'assets/images/smaran.jpeg',
    'assets/images/prv.png',
    'assets/images/naresh.jpeg',
  ];

  List<int> phoneNum = [
    09791175404,
    09442388179,
    04448135125,
    09650587881,
    07972229171,
    09444017750,
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
  final int phoneNum;

  CustomInfoWindow({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.phoneNum,
  }) : super(key: key);

  _launchPhoneDialer() async {
    final url = 'tel:$phoneNum';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching phone dialer: $e');
    }
  }

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
            onPressed:
                _launchPhoneDialer, // Call the function to open the phone dialer
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              primary: Colors.blue,
            ),
            child: Text('Call'), // Change button text to "Call"
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
              primary: Colors.red, // Change button color to red
            ),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
