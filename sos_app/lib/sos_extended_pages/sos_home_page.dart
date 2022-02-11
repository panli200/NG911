import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/routes/router.gr.dart';
import 'package:sos_app/data/application_data.dart';
import 'package:sos_app/services/call_type.dart';
import 'package:sos_app/widgets.dart';
import 'package:sos_app/profile_extended_pages/upload_file.dart';
import 'package:sos_app/services/location.dart';
import 'package:sos_app/services/send_call_history.dart';
import 'package:sos_app/services/send_realtime_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sos_app/sos_extended_pages/call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sos_app/profile_extended_pages/send_profile_data.dart';
import 'package:sos_app/profile_extended_pages/upload_file.dart';

class SosHomePage extends StatefulWidget {
  SosHomePage({Key? key}) : super(key: key);

  @override
  SosHomePageState createState() => SosHomePageState();
}

class SosHomePageState extends State<SosHomePage> {
  final howToUsePopUp = HowToUseData.howToUsePopUp;

  void _callNumber(String? date) async {
    Location location = Location();
    await location.getCurrentLocation();
    String user = FirebaseAuth.instance.currentUser!.uid.toString();
    String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    FirebaseFirestore.instance.collection('SOSEmergencies').doc(mobile).update({
      'Online': false,
      'Phone': mobile,
      'User': user,
      'StartLocation': GeoPoint(location.latitude, location.longitude),
      'StartTime': date,
      'Waiting': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            child: HowToUseButton(
                tileColor: howToUsePopUp.color,
                pageTitle: howToUsePopUp.title,
                onTileTap: () => context.router.push(
                      HowToUseRoute(
                        howToUseID: howToUsePopUp.id,
                      ),
                    ) // onTileTap
                ),
          ), // How To Use App Placeholder

          SizedBox(height: 20), // Spacing visuals

          Center(
            child: Text(
              'Make an emergency call for:',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),

          SizedBox(height: 20), // Spacing visuals

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Container(
                      child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () async{
                  WidgetsFlutterBinding.ensureInitialized();
                  var now = new DateTime.now();
                  String? date = now.toString();
                  _callNumber(date);
                  updateSensors(date);
                  sendUserDate(); //TEST calling send the user profile function to send the data to firebase
                  uploadFile(); //TEST upload files to the firebase storage
                  updateHistory(); //Test adding call history database
                  sendLocationHistory(); // send last 10 minutes "or less minutes since started" of location history
                  sendLocationHistory(); // send location each 5 seconds to FireBase
                  personal(); //Test adding call type
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CallPage()),
                  );
                },
                child: Text("Yourself"),
              ))),

              SizedBox(height: 20), // Spacing visuals

              Center(
                  child: Container(
                      child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  var now = new DateTime.now();
                  String? date = now.toString();
                  _callNumber(date);
                  updateSensors(date);
                  sendUserDate(); //TEST calling send the user profile function to send the data to firebase
                  uploadFile(); //TEST upload files to the firebase storage
                  updateHistory(); //Test adding call history database
                  sendLocationHistory();// send last 10 minutes "or less minutes since started" of location history
                  sendLocationHistory(); // send location each 5 seconds to FireBase
                  contact(); //Test adding call type
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CallPage()),
                  );
                },
                child: Text("Emergency Contact"),
              ))),

              SizedBox(height: 20), // Spacing visuals

              Center(
                  child: Container(
                      child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  var now = new DateTime.now();
                  String? date = now.toString();
                  _callNumber(date);
                  updateSensors(date);
                  updateHistory(); //Test adding call history database
                  sendLocationHistory();// send last 10 minutes "or less minutes since started" of location history
                  sendLocationHistory(); // send location each 5 seconds to FireBase
                  standby();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CallPage()),
                  );
                },
                child: Text("Third Party (Bystander)"),
              ))),

              // const Divider(
              //   height: 10,
              //   thickness: 5,
              // ),
            ],
          ) // SOS Scenario Button Placeholders
        ],
      ),
    ));
  }
}
