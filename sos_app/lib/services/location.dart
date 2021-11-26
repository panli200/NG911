import 'package:geolocator/geolocator.dart';

class Location {
  late double latitude;
  late double longitude;
  late double speed;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    latitude = position.latitude;
    longitude = position.longitude;
    speed = position.speed;

  }
}
