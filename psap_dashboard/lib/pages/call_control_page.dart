import 'package:flutter/material.dart';
import 'package:psap_dashboard/pages/maps_street.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallControlPanel extends StatefulWidget {
  const CallControlPanel({Key? key}) : super(key: key);

  @override
  State<CallControlPanel> createState() => _CallControlPanelState();
}

class _CallControlPanelState extends State<CallControlPanel> {
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('testCalls').snapshots();
  void _callPolice() async{
    const number = '01154703796'; //set the number here
  }
  void _callFireDepartment() async{
    const number = '01154703796'; //set the number here
  }
  void _callEMS() async{
    const number = '01154703796'; //set the number here
  }
  void _EndCall() async{
    const number = '01154703796'; //set the number here
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
                                                      'FirstName: Rabaa',

                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Address: 1234 5th Street, Regina, SK',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Device Charge: 89%',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Device Speed: 0 kph',
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