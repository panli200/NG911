import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sos_app/services/location.dart';
import 'package:battery/battery.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';

void sendRealTimeInfo() async {
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();

  DatabaseReference ref = FirebaseDatabase.instance.ref('users');

  final databaseMap = ref.child(mobile).child('map');

  Location location =  Location();
  await location.getCurrentLocation();

  Stream<DatabaseEvent> stream = ref.onValue;

  stream.listen((DatabaseEvent event) {
    databaseMap.update({
      'Latitude': location.latitude.toString(),
      'Longitude': location.longitude.toString(),
    });
  });
}


void updateSensors() async{



  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  final databaseReal = ref.child('sensors').child(mobile);



  // Acceleration
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  bool Danger = false;
  accelerometerEvents.listen((AccelerometerEvent event) {
    x = event.x;
    y = event.y;
    z = event.z;
    double AccelerationMagnitude = sqrt(
        pow(x, 2) + pow(y, 2) + pow(z, 2));
    if (AccelerationMagnitude > 10.0) {
      Danger = true;
    } else {
      Danger = false;
    }
    databaseReal.update(
        {
          'x-Acc': x,
          'y-Acc': y,
          'z-Acc': z,
        }
    );


  });

  // Location
  Location location =  Location();
  await location.getCurrentLocation();
  Stream<DatabaseEvent> stream = databaseReal.onValue;

  stream.listen((DatabaseEvent event) {
  databaseReal.update({
  'Latitude': location.latitude.toString(),
  'Longitude': location.longitude.toString(),
  });
  });

  // Battery
  var _battery = Battery();
  _battery.onBatteryStateChanged.listen((BatteryState state) {
    databaseReal.update(
        {
          'MobileCharge': _battery.batteryLevel.toString(),

        }
    );
  });
}

