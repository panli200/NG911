import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/data/application_data.dart';
import 'package:sos_app/routes/router.gr.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sos_app/services/location.dart';
import 'package:sos_app/services/weather.dart';
import 'package:sos_app/services/acceleration.dart';
import 'package:sensors/sensors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sos_app/services/location.dart';
import 'package:battery/battery.dart';
import 'dart:math';

class EmergencyCallPopUpPage extends StatelessWidget {

  final int emergencyCallPopUpID;

  const EmergencyCallPopUpPage({
    Key? key,
    @PathParam() required this.emergencyCallPopUpID,
  }) : super(key: key);

  void _callNumber() async{
    _updateSensors();



    const number = '01154703796'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);

  }

  void _updateSensors(){
    Location location = Location();
    location.getCurrentLocation();

    var _battery = Battery();
    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final databaseReal = ref.child('sensors').child('kgYjwJEbFNPP8JvD1PM8vcgxMxh2');

    // For display, can be delete in the future
    double x = 0.0;
    double y = 0.0;
    double z = 0.0;
    String Longitude = location.longitude.toString();
    String Latitude = location.latitude.toString();
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
      String batLevel= _battery.batteryLevel.toString();
      databaseReal.update(
          {
            'Latitude': location.latitude.toString(),
            'Longitude': location.longitude.toString(),
            'x-Acc': x,
            'y-Acc': y,
            'z-Acc': z,
            'MobileCharge': batLevel,
          }
      );


    });
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      databaseReal.update(
          {
            'MobileCharge': _battery.batteryLevel.toString(),

          }
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    final emergencyCallPopUp = EmergencyCallPopUpData.emergencyCallPopUp;
    final connectPsapData = ConnectPsapData.connectPsapData;

    return Scaffold (
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emergencyCallPopUp.title,
                style: Theme.of(context).textTheme.headline4,
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                'Who is this call for?',
                textAlign: TextAlign.center,
              ),

              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.center,
                      child:ElevatedButton(
                          child: Text("Yourself"),
                          onPressed: () => context.router.push(
                            ConnectPsapRoute(
                              connectPsapPageID: connectPsapData.id,
                            ),
                          )
                      )

                ), 
              ), 

              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.center,
                  //color: Colors.grey,
                      child:ElevatedButton(
                          child: Text("Emergency Contact"),
                          onPressed: _callNumber // this will the method for your rejected Button
                      )
                ), 
              ), 
              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.center,
                  //color: Colors.grey,
                      child:ElevatedButton(
                          child: Text("Third Party (Bystander)"),
                          onPressed: _callNumber,  // this will the method for your rejected Button
                      )
                ), 
              ), 
            ],
          ),
        ),
      ),
    );
  }
}