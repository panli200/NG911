import 'dart:async';
import 'package:sensors/sensors.dart';

class Acceleration {
  Acceleration() {
    String accelerationAdded = "";
    double accelerationX = 0;
    double accelerationY = 0;
    double accelerationZ = 0;
    accelerometerEvents.listen((AccelerometerEvent event) {
      accelerationX = event.x;
      accelerationY = event.y;
      accelerationZ = event.z;
    });
    Timer.periodic(Duration(seconds: 5), (t) {
      accelerationAdded = "x: " +
          accelerationX.toString() +
          "\n" +
          "y: " +
          accelerationY.toString() +
          "\n" +
          "z: " +
          accelerationZ.toString();
      accelerationController.sink.add(accelerationAdded);
    });
  }

  final accelerationController = StreamController<String>.broadcast();

  Stream<String> get stream => accelerationController.stream;
}
