import 'package:sensors/sensors.dart';
import 'dart:math';

class AccelerationAnalyzer {

  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  Future<void> getAcceleration() async {
    //For display, can be delete in the future
    await accelerometerEvents.listen((AccelerometerEvent event) {
      x = event.x;
      y = event.y;
      z = event.z;
    });
  }


  bool isAccident() {
    double ? AccelerationMagnitude = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
    if (AccelerationMagnitude > 10.0) {
      return true;
    }
    return false;
  }

}

