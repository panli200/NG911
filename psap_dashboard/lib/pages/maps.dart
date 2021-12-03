import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:ui' as ui;

class GoogleMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String htmlId = "7";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = LatLng(50.4452, -104.6189);

      final mapOptions = MapOptions()
        ..zoom = 6
        ..center = LatLng(53.2, -104.70);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);

      final marker = Marker(MarkerOptions()
        ..position = myLatlng
        ..map = map
        ..title = 'Hello World!');

      final infoWindow =
      InfoWindow(InfoWindowOptions()..content = 'caller');
      marker.onClick.listen((event) => infoWindow.open(map, marker));
      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }
}
