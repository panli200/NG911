import 'package:flutter/material.dart';
import 'package:psap_dashboard/pages/maps_street.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'maps_home_page.dart';

class CallControlPanel extends StatefulWidget {
  final CallerId;
  final Snapshot;
  const CallControlPanel({Key? key, required this.CallerId, required this.Snapshot}) : super(key: key);

  @override
  State<CallControlPanel> createState() => _CallControlPanelState();
}

class _CallControlPanelState extends State<CallControlPanel> {


  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('testCalls').snapshots();
  var FriendID;
  var snapshot;
  var realTimeSnapshot;
  var path;
  var MobileChargeString;
  var LongitudeString;
  var LatitudeString;
  var xAccString;
  var yAccString;
  var zAccString;
  var endTime;

  DatabaseReference? _db;
  void _callPolice() async{
    const number = '01154703794'; //set the number here
  }
  void _callFireDepartment() async{
    const number = '01154703795'; //set the number here
  }
  void _callEMS() async{
    const number = '01154703796'; //set the number here
  }
  void _EndCall() async{

    var now = new DateTime.now();
    var date = now.toString();

    FirebaseFirestore.instance.collection('SOSEmergencies').doc(FriendID).update({'Online': false});

    FirebaseFirestore.instance.collection('SOSUsers').doc(FriendID).collection('Emergencies').doc('Emergency' + date).update(
      {
        'endTime: ': FieldValue.serverTimestamp(),
      }
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (
                context) =>const MapsHomePage()));
  }

  void activateListeners(){
    ref.child('sensors').child(FriendID).child('MobileCharge').onValue.listen((event) {
      String MobileCharge = event.snapshot.value.toString();
      setState((){
        MobileChargeString = 'Mobile Charge: ' + MobileCharge;
      });
    });

    ref.child('sensors').child(FriendID).child('Longitude').onValue.listen((event) {
      String Longitude = event.snapshot.value.toString();
      setState((){
        LongitudeString = 'Longitude: ' + Longitude;
      });
    });

    ref.child('sensors').child(FriendID).child('Latitude').onValue.listen((event) {
      String Latitude = event.snapshot.value.toString();
      setState((){
        LatitudeString = 'Latitude: ' + Latitude;
      });
    });

    ref.child('sensors').child(FriendID).child('x-Acc').onValue.listen((event) {
      String xAcc = event.snapshot.value.toString();
      setState((){
        xAccString = 'Acceleration x: ' + xAcc;
      });
    });

    ref.child('sensors').child(FriendID).child('y-Acc').onValue.listen((event) {
      String yAcc = event.snapshot.value.toString();
      setState((){
        yAccString = 'Acceleration y: ' + yAcc;
      });
    });

    ref.child('sensors').child(FriendID).child('z-Acc').onValue.listen((event) {
      String zAcc = event.snapshot.value.toString();
      setState((){
        zAccString = 'Acceleration z: ' + zAcc;
      });
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FriendID = widget.CallerId; //Getting user ID from the previous page..
    activateListeners();
    
    snapshot = widget.Snapshot;
    FirebaseFirestore.instance.collection('SOSEmergencies').doc(FriendID).update({'Waiting': false}); // Changing the caller's Waiting state to be False
    FirebaseFirestore.instance.collection('SOSEmergencies').doc(FriendID).update({'Online': true}); // Changing the caller's Online state to be True
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Incoming Call Control Panel"),
          backgroundColor: Colors.redAccent,

        ),
        body: Column(
            children: <Widget>[
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Row(
                      children: <Widget>[
                        Column( // First Column

                            children: <Widget>[
                              Row( // For Map
                                  children: <Widget>[
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.45,
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      child: StreetMap(),
                                    )
                                  ]
                              ),
                              Row( // For Call History
                                  children: <Widget>[
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.20,
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: Scrollbar(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Caller History',
                                                      style: TextStyle(fontSize: 25),
                                                      textAlign: TextAlign.center,

                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '13 December 2012',

                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '8 January 2009',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),),
                                      ),
                                    )
                                  ]
                              ),
                              Row( // For Closing the call
                                  children: <Widget>[
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.10,
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: ElevatedButton(
                                          child: Text("End Call"),
                                          onPressed: _EndCall, // this will the method for your rejected Button
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                                          )
                                      ),
                                    )]
                              )
                            ]
                        ),
                        Column( // Second Column
                            children: <Widget>[
                              Row( // Caller's video stream
                                  children: <Widget>[
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.45,
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      child: Image.asset(
                                          "assets/images/video.jpg",
                                          fit: BoxFit.cover
                                      ),
                                    )
                                  ]
                              ),
                              Row( // Caller's Information
                                  children: <Widget>[
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.15,
                                      width: MediaQuery.of(context).size.width * 0.20,
                                      child: Scrollbar(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Caller Information',
                                                      style: TextStyle(fontSize: 25),
                                                      textAlign: TextAlign.center,

                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Phone: ${snapshot['Phone']}',

                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '$MobileChargeString',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '$LongitudeString',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '$LatitudeString',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '$xAccString',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '$yAccString',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '$zAccString',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),),
                                      ),
                                    )
                                  ]
                              ),
                              Row( // Messaging
                                  children: <Widget>[
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.15,
                                      width: MediaQuery.of(context).size.width * 0.20,
                                      child: Scrollbar(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Messages',
                                                      style: TextStyle(fontSize: 25),
                                                      textAlign: TextAlign.center,

                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'User: Any message',

                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Dispatcher: Any reply',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Dispatcher: Any reply',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),),
                                      ),
                                    )
                                  ]
                              ),
                              Row(
                                children: [

                                  // Messages wil be typed here

                                ],
                              )
                            ]
                        ),
                        Column( // Third Column -----> Speed Dialing
                            children: <Widget>[


                              Row( // Police
                                  children: <Widget>[
                                    ElevatedButton(
                                        child: Text("Police"),
                                        onPressed: _callPolice,
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                                        )
                                    )
                                  ]
                              ),
                              Row( // Fire Station
                                  children: <Widget>[
                                    ElevatedButton(
                                        child: Text("Fire Department"),
                                        onPressed: _callFireDepartment,
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                                        )
                                    )
                                  ]
                              ),
                              Row( // EMS
                                  children: <Widget>[
                                    ElevatedButton(
                                        child: Text("EMS"),
                                        onPressed: _callEMS,
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                                        )
                                    )
                                  ]
                              )
                            ]
                        ),
                      ]
                  )
              )
            ]
        )


    );


  }
}