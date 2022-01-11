import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sos_app/services/location.dart';
import 'package:battery/battery.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';
import 'dart:async';

void sendRealTimeInfo() async {
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  StreamSubscription? streamSubscriptionEnded;
  DatabaseReference ref = FirebaseDatabase.instance.ref('users');
  final databaseReal = ref.child('sensors').child(mobile);
  final databaseMap = ref.child(mobile).child('map');
  bool? Ended;
  Location location = Location();
  await location.getCurrentLocation();

  Stream<DatabaseEvent> stream = ref.onValue;

  streamSubscriptionEnded =
  databaseReal.child('Ended').onValue.listen((event) async {
  bool? EndedB = event.snapshot?.value as bool;
  Ended = EndedB;
  });

  stream.listen((DatabaseEvent event) {
  if (Ended != true) {
  databaseMap.update({
  'Latitude': location.latitude.toString(),
  'Longitude': location.longitude.toString(),
  });
  }
  });
}

void updateSensors(String? time) async {
bool? Online;
bool? Ended;
StreamSubscription? streamSubscription;
StreamSubscription? streamSubscriptionEnded;
double x = 0.0;
double y = 0.0;
double z = 0.0;
final FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();
String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
final databaseReal = ref.child('sensors').child(mobile);

databaseReal.set({'StartTime': time, 'Online': false, 'Ended': false});

void onlinDoTheUpdate() async {
//  bool Danger = false;
//    accelerometerEvents.listen((AccelerometerEvent event) {
//      x = event.x;
//      y = event.y;
//      z = event.z;
////    double AccelerationMagnitude = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
////    if (AccelerationMagnitude > 10.0) {
////      Danger = true;
////    } else {
////      Danger = false;
////    }
//      databaseReal.update({
//        'x-Acc': x,
//        'y-Acc': y,
//        'z-Acc': z,
//      });
//    });
//
//// Location
//    Location location = Location();
//    await location.getCurrentLocation();
//    Stream<DatabaseEvent> stream = databaseReal.onValue;
//
//    stream.listen((DatabaseEvent event) {
//      databaseReal.update({
//        'Latitude': location.latitude.toString(),
//        'Longitude': location.longitude.toString(),
//      });
//    });
//
//// Battery
//    var _battery = Battery();
//    _battery.onBatteryStateChanged.listen((BatteryState state) {
//      databaseReal.update({
//        'MobileCharge': _battery.batteryLevel.toString(),
//      });
//    });
}

databaseReal.child('Online').onValue.listen((event) async {
bool OnlineB = event.snapshot.value as bool;
Online = OnlineB;
if (Online! == true && Ended != true) {
streamSubscription =
accelerometerEvents.listen((AccelerometerEvent event) {
x = event.x;
y = event.y;
z = event.z;
//    double AccelerationMagnitude = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
//    if (AccelerationMagnitude > 10.0) {
//      Danger = true;
//    } else {
//      Danger = false;
//    }
if (Ended != true) {
databaseReal.update({
'x-Acc': x,
'y-Acc': y,
'z-Acc': z,
});
}
});

// Location
Location location = Location();
await location.getCurrentLocation();
Stream<DatabaseEvent> stream = databaseReal.onValue;

streamSubscription = stream.listen((DatabaseEvent event) {
if (Ended != true) {
databaseReal.update({
'Latitude': location.latitude.toString(),
'Longitude': location.longitude.toString(),
});
}
});

// Battery
var _battery = Battery();
streamSubscription =
_battery.onBatteryStateChanged.listen((BatteryState state) {
if (Ended != true) {
databaseReal.update({
'MobileCharge': _battery.batteryLevel.toString(),
});
}
});

streamSubscriptionEnded =
databaseReal.child('Ended').onValue.listen((event) async {
bool? EndedB = event.snapshot?.value as bool;
Ended = EndedB;
if (Ended == true) {
streamSubscription?.pause();
databaseReal.remove();
ref.child('users').child(mobile).remove();
}
});
}
});
}
