import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/data/application_data.dart';
import 'package:sos_app/profile_extended_pages/send_profile_data.dart';
import 'package:sos_app/profile_extended_pages/upload_file.dart';
import 'package:sos_app/routes/router.gr.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sos_app/services/location.dart';
import 'package:sos_app/services/send_realtime_info.dart';
import 'package:sos_app/services/weather.dart';
import 'package:sos_app/services/acceleration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sos_app/services/location.dart';
import 'package:battery/battery.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:sos_app/sos_extended_pages/call.dart';
import 'package:sos_app/services/send_realtime_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyCallPopUpPage extends StatelessWidget {

  final int emergencyCallPopUpID;

  const EmergencyCallPopUpPage({
    Key? key,
    @PathParam() required this.emergencyCallPopUpID,
  }) : super(key: key);

  void _callNumber() async{

    Location location = Location();
    await location.getCurrentLocation();
    String user = FirebaseAuth.instance.currentUser!.uid.toString();
    String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    FirebaseFirestore.instance.collection('SOSEmergencies').doc(mobile).set(
        {'Online': false,
          'Phone': mobile,
          'User' : user,
          'StartLocation': GeoPoint(location.latitude, location.longitude),
          'StartTime': FieldValue.serverTimestamp(),
          'Waiting': true,
        }
        );

    //const number = '01154703798'; //set the number to call here
    //bool? res = await FlutterPhoneDirectCaller.callNumber(number);


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
                          onPressed:(){
                            _callNumber();
                            sendRealTimeInfo();//Test sending real time function
                            updateSensors();
                            sendUserDate(); //TEST calling send the user profile function to send the data to firebase
                            uploadFile(); //TEST upload files to the firebase storage
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CallPage()),
                            );
                          } // this will the method for your rejected Button
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
                          onPressed:(){
                            _callNumber();
                            sendRealTimeInfo();//Test sending real time function
                            updateSensors();
                            sendUserDate(); //TEST calling send the user profile function to send the data to firebase
                            uploadFile(); //TEST upload files to the firebase storage
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CallPage()),
                            );
                          }

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