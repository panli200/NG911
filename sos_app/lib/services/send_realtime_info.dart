import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sos_app/services/location.dart';
import 'package:battery/battery.dart';
import 'dart:async';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'acceleration.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref();
String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
final databaseReal = ref.child('sensors').child(mobile);

StreamSubscription? streamSubscription;
StreamSubscription? streamLocationSubscription;
StreamSubscription? streamSubscriptionEnded;

void updateSensors(String? time, String? publicKey, var aesKey) async {
  bool? online;
  bool? ended;
  StopWatchTimer _stopWatchTimer = StopWatchTimer();

  int batteryLevel = 0;
  Acceleration? accelerationC = Acceleration();
  String accelerationString = "";

  Location startLocation = Location();
  await startLocation.getCurrentLocation();
  Stream<DatabaseEvent> stream = databaseReal.onValue;
  int? counts;
  final key = await aesKey;
  final keyString = await key.extractBytes();
  String aesSecretKeyString = keyString.toString();
  databaseReal.set({
    'StartTime': time,
    'Online': false,
    'Ended': false,
    'startLatitude': startLocation.latitude.toString(),
    'startLongitude': startLocation.longitude.toString(),
    'caller_public_key': publicKey,
    'caller_aes_key': aesSecretKeyString
  });

  if (counts == null) {
    counts = 0;
  } else {
    counts++;
  }

  //Timer
  _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  _stopWatchTimer.secondTime.listen((value) {
    if (counts! == 0) {
      databaseReal.update({
        'Timer':
            StopWatchTimer.getDisplayTime(value * 1000, milliSecond: false),
      });
    }
  });

  // Acceleration Data
  databaseReal.child('Online').onValue.listen((event) async {
    bool onlineB = event.snapshot.value as bool;
    online = onlineB;
    if (online! == true && ended != true) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop); //Stop timer

      streamSubscription = accelerationC.stream.listen((event) {
        accelerationString = event;
        if (ended != true) {
          databaseReal.update({
            'Acceleration': accelerationString,
          });
        }
      });

      // Location Data
      Location location = Location();
      await location.getCurrentLocation();
      streamLocationSubscription = stream.listen((DatabaseEvent event) async {
        if (ended != true) {
          databaseReal.update({
            'Latitude': location.latitude.toString(),
            'Longitude': location.longitude.toString(),
            'Speed': location.speed.toString()
          });
        }
      });

      // Battery
      var _battery = Battery();
      streamSubscription =
          _battery.onBatteryStateChanged.listen((BatteryState state) async {
        batteryLevel = await _battery.batteryLevel;
        if (ended != true) {
          databaseReal.update({
            'MobileCharge': batteryLevel.toString(),
          });
        }
      });

      streamSubscriptionEnded =
          databaseReal.child('Ended').onValue.listen((event) async {
        bool? endedB = event.snapshot.value as bool;
        ended = endedB;
        if (ended == true) {
          streamSubscription!.cancel();
          streamLocationSubscription!.cancel();
          streamSubscriptionEnded!.cancel();
          databaseReal.remove();
        }
      });
    }
  });
}

void stopSensors() {
  streamSubscription!.cancel();
  streamLocationSubscription!.cancel();
  streamSubscriptionEnded!.cancel();
  databaseReal.remove();
}
