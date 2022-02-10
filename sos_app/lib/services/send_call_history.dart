import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sos_app/services/location.dart';
import 'package:sos_app/services/TwentyPoints.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
Future<void> updateHistory() async {
  Location location = Location();
  await location.getCurrentLocation();
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  var currentDay = DateTime.now();
  FirebaseFirestore.instance
      .collection('History')
      .doc(currentDay.toString())
      .set({
    'Phone': mobile,
    'Location': GeoPoint(location.latitude, location.longitude),
  });
}


Future<void> sendLocationHistory() async {
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  DocumentReference Emergency = FirebaseFirestore.instance.collection('SOSEmergencies').doc(mobile);
  final database = openDatabase(
    join(await getDatabasesPath(), 'sensor_database.db'),

  );
  Future<List<Sensor>> sensors() async {
    final db = await database;

    // Query the table for all sensor.
    final List<Map<String, dynamic>> maps = await db.query('sensors');

    // Convert the List<Map<String, dynamic> into a List<Sensor>.
    return List.generate(maps.length, (i) {
      return Sensor(
        id: maps[i]['id'],
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
      );
    });
  }
  List<Sensor> twentyPoints =  List.from(await sensors());

  int numberOfPoints = await twentyPoints.length;
  for(int i=0; i<numberOfPoints ; i++){
  String latitudePoint = "Latitude" + i.toString();
  String longitudePoint = "Longitude" + i.toString();
  await Emergency.collection("location").add({
  latitudePoint: twentyPoints[i].getLatitude(),
  longitudePoint: twentyPoints[i].getLongitude()
  });
  }
}
