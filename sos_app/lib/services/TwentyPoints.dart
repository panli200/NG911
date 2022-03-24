class Sensor {
  int id;
  String latitude;
  String longitude;

  Sensor({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String getLongitude() {
    return this.longitude;
  }

  String getLatitude() {
    return this.latitude;
  }

  @override
  String toString() {
    return 'Sensor{id: $id,latitude: $latitude, longitude: $longitude}';
  }
}
