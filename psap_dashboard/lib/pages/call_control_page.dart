import 'package:flutter/material.dart';
import 'package:psap_dashboard/pages/maps_street.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as FbDb;
import 'dart:async';
import 'maps_home_page.dart';

class CallControlPanel extends StatefulWidget {
  final CallerId;
  final Snapshot;
  const CallControlPanel(
      {Key? key, required this.CallerId, required this.Snapshot})
      : super(key: key);

  @override
  State<CallControlPanel> createState() => _CallControlPanelState();
}

class _CallControlPanelState extends State<CallControlPanel> {
//used for map_street file
  String? Latitude;
  String? Longitude;

  // End video streaming code

  final FbDb.FirebaseDatabase database = FbDb.FirebaseDatabase.instance;
  FbDb.DatabaseReference ref = FbDb.FirebaseDatabase.instance.ref();
  final Stream<QuerySnapshot> users =
  FirebaseFirestore.instance.collection('testCalls').snapshots();
  var FriendID;
  var snapshot;
  var realTimeSnapshot;
  var path;
  var MobileChargeString;
  String? LongitudeString;
  String? LatitudeString;
  var xAccString;
  var yAccString;
  StreamSubscription? streamSubscription;
//  Listener? startTimeListener;
//  Listener? mobileChargeListener;
//  Listener? longitudeListener;
//  Listener? latitiudeListener;
//  Listener? xaListener;
//  Listener? yaListener;
//  Listener? zaListener;
  var zAccString;
  String? StartTime;
  var endTime;
  final senttext = new TextEditingController();
  FbDb.DatabaseReference? _db;

  void _EndCall() async {
    print("Print inside call");
    var now = new DateTime.now();
    var date = now.toString();
    streamSubscription?.cancel();
    FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(FriendID)
        .update({'Online': false, 'Ended': true});

//    double? long = double.parse(LongitudeString!);
//    double? lat = double.parse(LatitudeString!);

    FirebaseFirestore.instance
        .collection('SOSUsers')
        .doc(FriendID)
        .collection('Emergencies')
        .doc(date)
        .set({
      'StartTime': StartTime,
      'EndTime': FieldValue.serverTimestamp()
//      'EndPoint': GeoPoint(lat, long)
    });

    // End records
    var collection = FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(FriendID)
        .collection("messages");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapsHomePage()));
  }

  void activateListeners() {
    bool? Ended;
    ref
        .child('sensors')
        .child(FriendID)
        .child('Ended')
        .onValue
        .listen((event) async {
      bool? EndedB = event.snapshot?.value as bool;
      Ended = EndedB;
    });

    streamSubscription = ref
        .child('sensors')
        .child(FriendID)
        .child('StartTime')
        .onValue
        .listen((event) {
      if (Ended != true) {
        setState(() {
          StartTime = event.snapshot.value.toString();
        });
      }
    });

    streamSubscription = ref
        .child('sensors')
        .child(FriendID)
        .child('MobileCharge')
        .onValue
        .listen((event) {
      if (Ended != true) {
        String MobileCharge = event.snapshot.value.toString();
        setState(() {
          MobileChargeString = 'Mobile Charge: ' + MobileCharge;
        });
      }
    });

    streamSubscription = ref
        .child('sensors')
        .child(FriendID)
        .child('Longitude')
        .onValue
        .listen((event) {
      if (Ended != true) {
        Longitude = event.snapshot.value.toString();
        setState(() {
          LongitudeString = 'Longitude: ' + Longitude!;
        });
      }
    });

    streamSubscription = ref
        .child('sensors')
        .child(FriendID)
        .child('Latitude')
        .onValue
        .listen((event) {
      if (Ended != true) {
        Latitude = event.snapshot.value.toString();
        setState(() {
          LatitudeString = 'Latitude: ' + Latitude!;
        });
      }
    });

    streamSubscription = ref
        .child('sensors')
        .child(FriendID)
        .child('x-Acc')
        .onValue
        .listen((event) {
      if (Ended != true) {
        String xAcc = event.snapshot.value.toString();
        setState(() {
          xAccString = 'Acceleration x: ' + xAcc;
        });
      }
    });

    streamSubscription = ref
        .child('sensors')
        .child(FriendID)
        .child('y-Acc')
        .onValue
        .listen((event) {
      if (Ended != true) {
        String yAcc = event.snapshot.value.toString();
        setState(() {
          yAccString = 'Acceleration y: ' + yAcc;
        });
      }
    });
    streamSubscription = ref
        .child('sensors')
        .child(FriendID)
        .child('z-Acc')
        .onValue
        .listen((event) {
      if (Ended != true) {
        String zAcc = event.snapshot.value.toString();
        setState(() {
          zAccString = 'Acceleration z: ' + zAcc;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FriendID = widget.CallerId; //Getting user ID from the previous page..
    ref.child('sensors').child(FriendID).update({'Online': true});
    activateListeners();

    snapshot = widget.Snapshot;
    FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(FriendID)
        .update({
      'Waiting': false
    }); // Changing the caller's Waiting state to be False
    FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(FriendID)
        .update(
        {'Online': true}); // Changing the caller's Online state to be True
  }

  @override
  void dispose() async {
    // clear users

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Query sorted = FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(FriendID)
        .collection('messages')
        .orderBy("time", descending: true);
    final Stream<QuerySnapshot> messages = sorted.snapshots();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Incoming Call Control Panel"),
          backgroundColor: Colors.redAccent,
        ),
        body: Column(children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Row(children: <Widget>[
                Column(// First Column

                    children: <Widget>[
                      Row(// For Map
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.30,
                              width: MediaQuery.of(context).size.width * 0.45,
                              child:
                              StreetMap(latitude: Latitude!, longitude: Longitude!),
                            )
                          ]),
                      Row(// For Call History
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.45,
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
                                  ),
                                ),
                              ),
                            )
                          ]),
                      Row(// For Closing the call
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.10,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: ElevatedButton(
                                  child: Text("End Call"),
                                  onPressed: () async {
                                    FbDb.DatabaseReference real =
                                    FbDb.FirebaseDatabase.instance.ref();
                                    final databaseReal =
                                    real.child('sensors').child(FriendID);

                                    await databaseReal
                                        .update({'Online': false, 'Ended': true});

                                    // End the call

                                    _EndCall(); // this will the method for your rejected Button
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 30),
                                  )),
                            )
                          ])
                    ]),
                Column(children: [
                  //////
                  // This is the User Info
                  //////
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 50,
                                child: Row(
                                  children: const [
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
                          ),
                        ],
                      )),

                  const Divider(
                    height: 5,
                    thickness: 3,
                  ),

                  //////
                  // This is the chat
                  //////
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Row(
                        children: [
                          Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: messages,
                                  builder: (
                                      BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot,
                                      ) {
                                    if (snapshot.hasError) {
                                      return Text('Something went wrong');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text('Loading');
                                    }

                                    final data = snapshot.requireData;
                                    return ListView.builder(
                                        reverse: true,
                                        itemCount: data.size,
                                        itemBuilder: (context, index) {
                                          Color c;
                                          Alignment a;
                                          if (data.docs[index]['SAdmin'] ==
                                              false) {
                                            c = Colors.blueGrey;
                                            a = Alignment.centerLeft;
                                          } else {
                                            c = Colors.lightGreen;
                                            a = Alignment.centerRight;
                                          }

                                          return SizedBox(
                                              child: Align(
                                                  alignment: a,
                                                  child: Container(
                                                    child: Text(
                                                      '  ${data.docs[index]['Message']}',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    constraints:
                                                    const BoxConstraints(
                                                      maxHeight:
                                                      double.infinity,
                                                    ),
                                                    padding:
                                                    EdgeInsets.all(10.0),
                                                    margin:
                                                    EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                      color: c,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          35.0),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            offset:
                                                            Offset(0, 3),
                                                            blurRadius: 5,
                                                            color: Colors.grey)
                                                      ],
                                                    ),
                                                  )));
                                        });
                                  })),
                        ],
                      )),

                  const Divider(
                    height: 5,
                    thickness: 3,
                  ),
                  //////
                  // This is the reply
                  //////
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Row(
                        children: [
                          Container(
                              height: 70,
                              constraints: const BoxConstraints(
                                maxHeight: double.infinity,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.all(20.0),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: senttext,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                            hintText: "Type Something...",
                                            hintStyle:
                                            TextStyle(color: Colors.white),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send,
                                          color: Colors.white),
                                      onPressed: () {
                                        String text = senttext.text;
                                        if (text != '') {
                                          FirebaseFirestore.instance
                                              .collection('SOSEmergencies')
                                              .doc(FriendID)
                                              .collection('messages')
                                              .add({
                                            'Message': text,
                                            'SAdmin': true,
                                            'time': FieldValue.serverTimestamp()
                                          });
                                          senttext.text = '';
                                        }
                                      },
                                    )
                                  ],
                                ),
                              )),
                        ],
                      )),
                ]),
              ]))
        ]));
  }
}
