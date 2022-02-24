import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sos_app/services/location.dart';
import 'package:battery/battery.dart';
import 'dart:async';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'acceleration.dart';

void updateSensors(String? time, String? publicKey, var aesKey) async {
  bool? Online;
  bool? Ended;
  StreamSubscription? streamSubscription;
  StreamSubscription? streamLocationSubscription;
  StreamSubscription? streamSubscriptionEnded;
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  int batteryLevel = 0;
  Acceleration? accelerationC = Acceleration();
  String accelerationString = "";
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  final databaseReal = ref.child('sensors').child(mobile);
  Location location = Location();
  await location.getCurrentLocation();
  Stream<DatabaseEvent> stream = databaseReal.onValue;
  int? counts;
  final key = await aesKey;
  final keyString = await key.extractBytes();
  String  aesSecretKeyString = keyString.toString();
  databaseReal.set({
    'StartTime': time,
    'Online': false,
    'Ended': false,
    'Latitude': location.latitude.toString(),
    'Longitude': location.longitude.toString(),
    'caller_public_key': publicKey,
    'caller_aes_key': aesSecretKeyString
  });
  //Timer

if(counts == null){
  counts = 0;
}else{
  counts++;
}
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    _stopWatchTimer.secondTime.listen((value) {
      if(counts! == 0){
      databaseReal.update({
        'Timer':
        StopWatchTimer.getDisplayTime(value * 1000, milliSecond: false),
      });}
    });

  // Acceleration Data
  databaseReal.child('Online').onValue.listen((event) async {
    bool OnlineB = event.snapshot.value as bool;
    Online = OnlineB;
    if (Online! == true && Ended != true) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop); //Stop timer

      streamSubscription = accelerationC?.stream.listen((event) {
        accelerationString = event;
        if (Ended != true) {
          databaseReal.update({
            'Acceleration': accelerationString,
          });
        }
      });

// Location and Speed
streamLocationSubscription = stream.listen((DatabaseEvent event) {
        if (Ended != true) {
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
        if (Ended != true) {
          databaseReal.update({
            'MobileCharge': batteryLevel.toString(),
          });
        }
      });

      streamSubscriptionEnded =
          databaseReal.child('Ended').onValue.listen((event) async {
        bool? EndedB = event.snapshot?.value as bool;
        Ended = EndedB;
        if (Ended == true) {
          streamSubscription!.cancel();
          streamLocationSubscription!.cancel();
          streamSubscriptionEnded!.cancel();
          databaseReal.remove();
        }
      });
    }
  });
}
