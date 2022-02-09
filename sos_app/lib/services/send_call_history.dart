import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sos_app/services/location.dart';
import 'package:sos_app/services/TwentyPoints.dart';
import 'package:sos_app/services/local_location.dart';

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

  DatabaseClass? db;
  List<Sensor> twentyPoints = await db!.sensors();

  int numberOfPoints = twentyPoints.length;

  for(int i=0; i<numberOfPoints ; i++){
  String latitudePoint = "Latitude" + i.toString();
  String longitudePoint = "Longitude" + i.toString();
  await Emergency.collection("location").add({
  latitudePoint: twentyPoints[i].getLatitude(),
  longitudePoint: twentyPoints[i].getLongitude()
  });
  }
}