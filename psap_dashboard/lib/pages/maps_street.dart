// import 'dart:html';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps/google_maps.dart';
// import 'dart:ui' as ui;
//
// class StreetMap extends StatefulWidget {
//   final previousLocs;
//   final callId;
//   final latitudePassed;
//   final longitudePassed;
//   final startLan;
//   final startLon;
//   const StreetMap({
//     Key? key,
//     this.previousLocs,
//     this.callId,
//     this.latitudePassed,
//     this.longitudePassed,
//     this.startLan,
//     this.startLon,
//   }) : super(key: key);
//
//   @override
//   State<StreetMap> createState() => _StreetMapState();
// }
//
// class _StreetMapState extends State<StreetMap> {
//   @override
//   Widget build(BuildContext context) {
//     String htmlId = "8";
//
//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
//       final myLatlng = LatLng(double.parse(widget.latitudePassed),
//           double.parse(widget.longitudePassed));
//
//       final mapOptions = MapOptions()
//         ..zoom = 19
//         ..center = myLatlng;
//
//       final elem = DivElement()
//         ..id = htmlId
//         ..style.width = "100%"
//         ..style.height = "100%"
//         ..style.border = 'none';
//
//       final map = GMap(elem, mapOptions);
//
//       var newLocs = [
//         LatLng(double.parse(widget.startLan), double.parse(widget.startLon))
//       ];
//
//       Stream locationsHistory = FirebaseFirestore.instance
//           .collection('SOSEmergencies')
//           .doc(widget.callId)
//           .collection('NewLocations')
//           .snapshots();
//
//       locationsHistory.listen((event) async {
//         newLocs.add(LatLng(double.tryParse(event.docs.indexOf('latitude')),
//             double.tryParse(event.docs.indexOf('longitude'))));
//
//         Polyline(PolylineOptions()
//           ..map = map
//           ..path = widget.previousLocs);
//
//         Polyline(PolylineOptions()
//           ..map = map
//           ..path = newLocs
//           ..strokeColor = "#c4161b");
//
//         Marker(MarkerOptions()
//           ..position = myLatlng
//           ..map = map);
//       });
//
//       return elem;
//     });
//
//     return HtmlElementView(viewType: htmlId);
//   }
// }
