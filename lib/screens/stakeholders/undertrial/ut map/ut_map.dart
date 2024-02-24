// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'dart:async';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:law_help/screens/login/login_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ut_map_alert.dart';

class UTMap extends StatefulWidget {
  const UTMap({Key? key}) : super(key: key);

  @override
  State<UTMap> createState() => _UTMapState();
}

class _UTMapState extends State<UTMap> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(13.043554623623109, 80.23367539609262), //T Nagar
    zoom: 12,
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
    "Sheoran & Associates",
    "Mehra And Associates",
    "Ahluwalia Anil Kumar & Associates",
    "Nawabi Law Associates",
    "Advocate Deepika Sinha",
    "Adv.M P Salunke & Legal Associates",
    "Advocate Sumant Tuteja",
    "Shalini Law Firm",
    "Manoj Shrimal & Associates",
    "Advocate Anil Kumar Singh",
    "Jharna N Jadwani",
    "Adv.Tapan Choudhury",
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
    "Services in law relating Criminal, civil, service, arbitration and matrimonial cases at Jaipur etc.",
    "Bankruptcy-Creditors, Bankruptcy-Debtors, Business Litigation, Child Custody, Civil Litigation, Civil Rights, Consumer Law etc.",
    "Separation, Spousal Support, Alimony, Equitable Distribution, Child Custody, Child Visitation, Child Support, Emancipation Motions etc.",
    "Probate, Real Estate, Wills etc.",
    "Sexual Harrasement, Drugs, Personal Defence etc.",
    "Criminal Litigation, Disability Rights, Human Rights etc.",
    "Adoption, Appellate Practice, Arbitration, Banking etc.",
    "Business Litigation, Child Custody, Civil Litigation, Civil Rights etc.",
    "Adoption, Appellate Practice, Arbitration, Mediation, Banking etc.",
    "Criminal, Divorce/Domestic Relations, Family Law, Land Use etc.",
    "Criminal law, Domestic Relations, Drugs, Terrorism Law etc.",
    "Arbitration, Mediation, Banking, Child Custody, Child Support, etc.",
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
    1412262495,
    9958709869,
    1722740127,
    9978761592,
    9304033771,
    9766707764,
    9888195414,
    9885515039,
    9425317141,
    9087648902,
    9974996878,
    9650499965,
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
    const LatLng(
        26.978530766072744, 75.76379025631091), //IFF Law Attorney Law Firm
    const LatLng(28.581542808786295,
        77.24180343018377), //Advocate Krishna And Associates
    const LatLng(30.763054558468568, 76.79907228495355), //Aran Law Firm
    const LatLng(26.93052522454886, 80.93780579450484), //S.Maran, Advocate
    const LatLng(23.3443423202182, 85.32821064500827), // PRV Law Firm
    const LatLng(
        18.49535724494806, 73.85759413834084), //Mr.J.N.NARESH KUMAR //Pro Bono
    const LatLng(31.656632579712813, 74.86501745112542), //shape legal
    const LatLng(17.49621623033761, 78.35123966191334), //Advocate Robin
    const LatLng(22.719768868803968, 75.86415899172687), //Advocate Arnab
    const LatLng(25.34518327560324, 82.97954059619641), // Advocate Jubina
    const LatLng(20.378502875449136, 72.92856165314275), //  advocate s singh
    const LatLng(22.53843234458821, 88.36337594774955), // J
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
    loadData();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _logout(BuildContext context) async {
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    prefs.remove('email');
    prefs.remove('caseNumber');
    prefs.remove('isLoggedIn');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void loadData() async {
    for (int i = 0; i < _latLang.length; i++) {
      Uint8List? markerIcon =
          await getBytesFromAssets('assets/images/lawyer copy.png', 160);

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
                  context: context,
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
        actions: [
          IconButton(
            onPressed: () {
              _logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          markers: Set<Marker>.of(_markers),
          myLocationEnabled: true,
        ),
      ),
    );
  }
}
