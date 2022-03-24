import 'package:geolocator/geolocator.dart';

class Location {
  late double latitude = 0.0;
  late double longitude = 0.0;
  late double speed = 0.0;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    latitude = position.latitude;
    longitude = position.longitude;
    speed = position.speed;
  }
}
