import 'package:flutter/material.dart';
import 'package:psap_dashboard/pages/maps_street.dart';

class CallControlPanel extends StatefulWidget {
  const CallControlPanel({Key? key}) : super(key: key);

  @override
  State<CallControlPanel> createState() => _CallControlPanelState();
}

class _CallControlPanelState extends State<CallControlPanel> {
  void _callPolice() async{
    const number = '01154703796'; //set the number here
  }
  void _callFireDepartment() async{
    const number = '01154703796'; //set the number here
  }
  void _callEMS() async{
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
                                          child: Text("Calling History here")
                                      )
                                    ]
                                ),
                                Row( // For Closing the call
                                    children: <Widget>[
                                      SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.20,
                                          width: MediaQuery.of(context).size.width * 0.35,
                                          child: Text("Close Call here")
                                      )
                                    ]
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
                                          child: Text(" Caller's Video Stream here")
                                      )
                                    ]
                                ),
                                Row( // Caller's Information
                                    children: <Widget>[
                                      SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.20,
                                          width: MediaQuery.of(context).size.width * 0.20,
                                          child: Text("Caller's Information here")
                                      )
                                    ]
                                ),
                                Row( // Messaging
                                    children: <Widget>[
                                      SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.20,
                                          width: MediaQuery.of(context).size.width * 0.20,
                                          child: Text("Messaging Caller here")
                                      )
                                    ]
                                )
                                ]
                          ),
                          Column( // Third Column -----> Speed Dialing
                              children: <Widget>[
                                  Row( // Police
                                      children: <Widget>[
                                        ElevatedButton(
                                            child: Text("Police"),
                                            onPressed: _callPolice
                                        )
                                      ]
                                  ),
                                  Row( // Fire Station
                                      children: <Widget>[
                                        ElevatedButton(
                                            child: Text("Fire Department"),
                                            onPressed: _callFireDepartment
                                        )
                                      ]
                                  ),
                                  Row( // EMS
                                      children: <Widget>[
                                        ElevatedButton(
                                            child: Text("EMS"),
                                            onPressed: _callEMS
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