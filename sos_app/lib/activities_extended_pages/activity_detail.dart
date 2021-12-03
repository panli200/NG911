import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sos_app/services/location.dart';
import 'package:sos_app/services/weather.dart';
import 'package:sos_app/services/acceleration.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';
class ActivityDetailPage extends StatefulWidget {
  final Snapshot;

  const ActivityDetailPage({Key? key, required this.Snapshot})
      : super(key: key);

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  Location location = Location(); // For display, can be delete in the future
  WeatherModel weather = WeatherModel(); //For display, can be delete in the future
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  bool Danger = false;
  void initState() {
    //For display, can be delete in the future
    super.initState();
    getLocationData();


    accelerometerEvents.listen((AccelerometerEvent event) {
        setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
        double AccelerationMagnitude = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
        if (AccelerationMagnitude > 10.0) {
          Danger =  true;
        }else{
          Danger = false;
        }

      });
    });
    }



  Future<void> getLocationData() async {
    //For display, can be delete in the future

    await location.getCurrentLocation();
    await weather.getLocationWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Center(
            child: Text(
                'Date: ${widget.Snapshot['Date']}\n Start time: ${widget.Snapshot['StartTime']}\n End Time: ${widget.Snapshot['EndTime']}\n Status: ${widget.Snapshot['Status']}')),
        //This for display sensors information, can be delete in the future------
        Row(children: [
          Text('Accelerometer: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(
            'X: ' + x.toStringAsFixed(2) + ' Y: ' + y.toStringAsFixed(2) + ' Z: ' + z.toStringAsFixed(2) + " Danger: " + Danger.toString()
          ),
        ]),
        Row(children: [
          Text('Latitude: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(
            location.latitude.toString(),
          ),
        ]),
        Row(children: [
          Text('Longitude: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(
            location.longitude.toString(),
          ),
        ]),
        Row(
          children: [
            Text('Current Speed: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(
              location.speed.toString(),
            ),
          ],
        ),
        Row(
          children: [
            Text('Humidity: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(
              weather.humidity.toString(),
            ),
          ],
        ),
        Row(
          children: [
            Text('WindSpeed: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(
              weather.windSpeed.toString(),
            ),
            Text (' km/h'),
          ],
        ),
        Row(
          children: [
            Text('Temperature: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(
              weather.temperature.toString(),
            ),
            Text (' celsius'),
          ],
        ),
        Row(
          children: [
            Text('Weather Description: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(
              weather.weatherDescription,
            ),
          ],
        ),//Delete until here
      ],
    ));
  }
}
