import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:html';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';

class GoogleMap extends StatefulWidget {
  const GoogleMap({Key? key}) : super(key: key);

  @override
  State<GoogleMap> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  late var map;
  late var elem = DivElement();
  var mapOptions = MapOptions()
    ..zoom = 6
    ..center = LatLng(53.2, -104.70);
  void refresh() {
    DatabaseReference ref = FirebaseDatabase.instance.ref('sensors');
    Stream<DatabaseEvent> stream = ref.onValue;
    Timer.periodic(const Duration(seconds: 10), (locationTimer) async {
      setState(() {
        map = GMap(elem, mapOptions);
        stream.listen((DatabaseEvent event) async {
          for (var doc in event.snapshot.children) {
            if (double.tryParse(doc.child('startLatitude').value.toString()) !=
                    null &&
                double.tryParse(doc.child('startLongitude').value.toString()) !=
                    null) {
              var marker = LatLng(
                  double.tryParse(doc.child('startLatitude').value.toString()),
                  double.tryParse(
                      doc.child('startLongitude').value.toString()));

              if (doc.child('Online').value == false &&
                  doc.child('Ended').value == false) {
                Marker(MarkerOptions()
                  ..position = marker
                  ..map = map);
              }
              if (doc.child('Online').value == true &&
                  doc.child('Ended').value == false) {
                Marker(MarkerOptions()
                  ..position = marker
                  ..map = map
                  ..icon =
                      'https://maps.google.com/mapfiles/ms/icons/blue-dot.png');
              }
            }
          }
        });
      });
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String htmlId = "7";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      var mapOptions = MapOptions()
        ..zoom = 6
        ..center = LatLng(53.2, -104.70);

      elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      map = GMap(elem, mapOptions);
      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }
}
