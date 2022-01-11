import 'dart:html';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:ui' as ui;

class GoogleMap extends StatefulWidget {
  const GoogleMap({Key? key}) : super(key: key);

  @override
  State<GoogleMap> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String htmlId = "7";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final mapOptions = MapOptions()
        ..zoom = 6
        ..center = LatLng(53.2, -104.70);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);

      DatabaseReference ref = FirebaseDatabase.instance.ref('sensors');
      Stream<DatabaseEvent> stream = ref.onValue;
      stream.listen((DatabaseEvent event) async {
        for (var doc in event.snapshot.children) {
          var marker = LatLng(
              double.parse(doc.child('Latitude').value.toString()),
              double.parse(doc.child('Longitude').value.toString()));

          Marker(MarkerOptions()
            ..position = marker
            ..map = map);
        }
      });

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }
}
