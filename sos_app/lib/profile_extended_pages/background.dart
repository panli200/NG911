import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sos_app/services/location.dart';

class Background {
  final service = FlutterBackgroundService();
  Background() {
    initializeService();
  }

  Future<bool> isRunning() async {
    var isRunning = await service.isServiceRunning();
    return isRunning;
  }

  Future<void> initializeService() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );
  }

  void onIosBackground() {
    WidgetsFlutterBinding.ensureInitialized();
    print('FLUTTER BACKGROUND FETCH');
  }

  void onStart() {
    WidgetsFlutterBinding.ensureInitialized();
    final service = FlutterBackgroundService();
    service.onDataReceived.listen((event) {
      if (event!["action"] == "setAsForeground") {
        service.setForegroundMode(true);
        return;
      }

      if (event["action"] == "setAsBackground") {
        service.setForegroundMode(false);
      }

      if (event["action"] == "stopService") {
        service.stopBackgroundService();
      }
    });

    // bring to foreground
    service.setForegroundMode(true);
    Timer.periodic(Duration(seconds: 10), (timer) async {
      if (!(await service.isServiceRunning())) timer.cancel();
      service.setNotificationInfo(
        title: "SOS System",
        content: "Listening to location",
      );

      Location location = Location();
      await location.getCurrentLocation();

      service.sendData(
        {
          "current_lat": location.latitude.toString(),
          "current_long": location.longitude.toString()
        },
      );
    });
  }
}
