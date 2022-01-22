import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as FbDb;
import 'package:weather/weather.dart';
import 'dart:async';
import 'maps_home_page.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'signaling.dart';
import 'package:google_maps/google_maps.dart' as googleMap;
import 'dart:ui' as ui;
import 'dart:html';

// Enviromental variables
String? latitudePassed;
String? longitudePassed;

class CallControlPanel extends StatefulWidget {
  final CallerId;
  final Snapshot;
  final signaling;
  final remoteRenderer;
  final localRenderer;
  const CallControlPanel({Key? key, required this.CallerId, required this.Snapshot, required this.signaling,required this.localRenderer,this.remoteRenderer})
      : super(key: key);

  @override
  State<CallControlPanel> createState() => _CallControlPanelState();
}

class _CallControlPanelState extends State<CallControlPanel> {
  // RealTime database
  final FbDb.FirebaseDatabase database = FbDb.FirebaseDatabase.instance;
  FbDb.DatabaseReference ref = FbDb.FirebaseDatabase.instance.ref();

  // database variables
  var callerId = '';
  var snapshot;
  Query? pastCalls;
  // States of the call
  bool? ended = false;

  //used for map_street file
  String htmlId = "8";
  StreetMap? streetMap;

  // weather data
  double? humidity = 0.0;
  int? temperature = 0;
  double? windSpeed = 0.0;
  String? weatherDescription = '';

  // acceleration and location/speed data
  String? AccelerationString = '';
  String? yAccelerationString = '';
  String? zAccelerationString = '';
  String? longitudeString = '';
  String? latitudeString = '';
  String? speedString = '';

  // other sensors
  String mobileChargeString = '';

  //Video Audio Stream
  Signaling? signaling ;
  RTCVideoRenderer? _localRenderer ;
  RTCVideoRenderer? _remoteRenderer ;

  // Listeners
  StreamSubscription? endedStateStream;
  StreamSubscription? startTimeStream;
  StreamSubscription? batteryStream;
  StreamSubscription? longitudeStream;
  StreamSubscription? latitudeStream;
  StreamSubscription? speedStream;
  StreamSubscription? AccelerationStream;
  StreamSubscription? roomIdAccelerationStream;

  String? StartTime;
  final sentText = TextEditingController();

  var roomId;

  // Function to display the map

  // Function to end the call
  void _EndCall() async {
    // Closing the listeners
    startTimeStream?.cancel();
    batteryStream?.cancel();
    longitudeStream?.cancel();
    latitudeStream?.cancel();
    speedStream?.cancel();

    roomIdAccelerationStream?.cancel();

    // Changing the states
    await FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .update({'Online': false, 'Ended': true});

    // Write activity
    CollectionReference user =
        FirebaseFirestore.instance.collection('SoSUsers');
    await user.doc(callerId).collection('Emergencies').add({
      'StartTime': StartTime,
      'EndTime': FieldValue.serverTimestamp(),
      'EndPointLatitude': latitudePassed,
      'EndPointLongitude': longitudePassed
    });

    // End records
    var collection = FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .collection("messages");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    // Ending the endState stream
    endedStateStream?.cancel();

    // Going back to maps home page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapsHomePage()));
  }

  void activateListeners() {
    endedStateStream = ref
        .child('sensors')
        .child(callerId)
        .child('Ended')
        .onValue
        .listen((event) async {
      bool? endedB = event.snapshot.value as bool;
      ended = endedB;
    });

    startTimeStream = ref
        .child('sensors')
        .child(callerId)
        .child('StartTime')
        .onValue
        .listen((event) {
      if (ended != true) {
        setState(() {
          StartTime = event.snapshot.value.toString();
        });
      }
    });

    batteryStream = ref
        .child('sensors')
        .child(callerId)
        .child('MobileCharge')
        .onValue
        .listen((event) {
      if (ended != true) {
        String mobileCharge = event.snapshot.value.toString();
        setState(() {
          mobileChargeString = 'Mobile Charge: ' + mobileCharge;
        });
      }
    });

    longitudeStream = ref
        .child('sensors')
        .child(callerId)
        .child('Longitude')
        .onValue
        .listen((event) {
      if (ended != true) {
        longitudePassed = event.snapshot.value.toString();
        setState(() {
          longitudeString = 'Longitude: ' + longitudePassed!;
        });
      }
    });

    latitudeStream = ref
        .child('sensors')
        .child(callerId)
        .child('Latitude')
        .onValue
        .listen((event) {
      if (ended != true) {
        latitudePassed = event.snapshot.value.toString();
        setState(() {
          latitudeString = 'Latitude: ' + latitudePassed!;
        });
      }
    });

    speedStream = ref
        .child('sensors')
        .child(callerId)
        .child('Speed')
        .onValue
        .listen((event) {
      if (ended != true) {
        String speed = event.snapshot.value.toString();
        setState(() {
          speedString = 'Speed: ' + speed;
        });
      }
    });

    AccelerationStream = ref
        .child('sensors')
        .child(callerId)
        .child('Acceleration')
        .onValue
        .listen((event) {
      if (ended != true) {
        String AccelerationValue = event.snapshot.value.toString();
        setState(() {
          AccelerationString =  AccelerationValue;
        });
      }
    });



  }

//  void pauseListeners(){
//    Timer.periodic(Duration(seconds: 1), (timer)
//    async{
//      startTimeStream?.pause();
//      batteryStream?.pause();
//      longitudeStream?.pause();
//      latitudeStream?.pause();
//      xAccelerationStream?.pause();
//      yAccelerationStream?.pause();
//      zAccelerationStream?.pause();
//      roomIdAccelerationStream?.pause();
//      await Future.delayed(Duration(seconds: 1));
//      startTimeStream?.resume();
//      batteryStream?.resume();
//      longitudeStream?.resume();
//      latitudeStream?.resume();
//      xAccelerationStream?.resume();
//      yAccelerationStream?.resume();
//      zAccelerationStream?.resume();
//      roomIdAccelerationStream?.resume();
//    });
//  }

  void getRoomId() {
    roomIdAccelerationStream = ref
        .child('sensors')
        .child(callerId)
        .child('RoomID')
        .onValue
        .listen((event) {
      roomId = event.snapshot.value.toString();
    });
  }

  Future<void> getLocationWeather() async {
    WeatherFactory wf = WeatherFactory("5e1ad24d143d638f46a53ae6403ee651");
    Weather w = await wf.currentWeatherByLocation(
        double.parse(latitudePassed!), double.parse(longitudePassed!));
    weatherDescription = w.weatherDescription;
    humidity = w.humidity!;
    windSpeed = w.windSpeed!;
    temperature = w.temperature!.celsius!.toInt();
  }

  // Initialize
  @override
  void initState() {
    // Google map initialize

    callerId = widget.CallerId; //Getting user ID from the previous page..
    getRoomId();
     signaling = widget.signaling;
     _localRenderer = widget.localRenderer;
     _remoteRenderer = widget.remoteRenderer;

    signaling?.joinRoom(
        roomId, _remoteRenderer!, callerId); //join the video stream

    ref.child('sensors').child(callerId).update({'Online': true});
    activateListeners();
    getLocationWeather();
//    pauseListeners();

    // Changing states
    snapshot = widget.Snapshot;
    FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .update({
      'Waiting': false,
      'Online': true
    }); // Changing the caller's Waiting state to be False and Online state to be True
    super.initState();
    //String UserMedicalReport = "";
  }

  @override
  void dispose() async {
    // clear users
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // To get the messages sent
    final Query sortedMessages = FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .collection('messages')
        .orderBy("time", descending: true);
    final Stream<QuerySnapshot> messages = sortedMessages.snapshots();
    // To get the history of the caller "past calls"
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
                      height: MediaQuery.of(context).size.height * 0.70,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: StreetMap(),
                    )
                  ]),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.25,
                  ),
                  Row(// For Closing the call
                      children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: ElevatedButton(
                          child: const Text("End Call"),
                          onPressed: () async {
                            signaling!.hangUp(_localRenderer!, roomId, callerId);
                            FbDb.DatabaseReference real =
                                FbDb.FirebaseDatabase.instance.ref();
                            final databaseReal =
                                real.child('sensors').child(callerId);

                            await databaseReal
                                .update({'Online': false, 'Ended': true});

                            // End the call

                            _EndCall(); // this will the method for your rejected Button
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          )),
                    )
                  ])
                ]),
                Column(children: [
                  // Second Column
                  //////
                  // This is the User Info
                  //////
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Caller Information',
                                style: TextStyle(fontSize: 25),
                              ),
                              Text(
                                'Weather: ' + weatherDescription!,
                              ),
                              Text(
                                'Temperature in Degree: ' +
                                    temperature!.toString(),
                              ),
                              Text(
                                'Humidity: ' + humidity!.toString(),
                              ),
                              Text(
                                'Wind Speed: ' + windSpeed!.toString(),
                              ),
                              Text(
                                'Phone: ${snapshot['Phone']}',
                              ),
                              Text(
                                mobileChargeString,
                              ),
                              Text(
                                '$longitudeString',
                              ),
                              Text(
                                '$latitudeString',
                              ),
                              Text(
                                '$speedString',
                              ),
                              Text(
                                '$AccelerationString',
                              ),

                            ],
                          ),
                        ],
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Row(
                      children: [
                        Column(children: [
                          ElevatedButton(
                              onPressed: _EndCall,
                              child: const Text(
                                  "Download Personal Medical Report")),
                          ElevatedButton(
                              onPressed: _EndCall,
                              child: const Text(
                                  "Download Emergency Contact Medical Report")),
                          //////
                          // This is the chat
                          //////
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: messages,
                                          builder: (
                                            BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot,
                                          ) {
                                            if (snapshot.hasError) {
                                              return const Text(
                                                  'Something went wrong');
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Text('Loading');
                                            }

                                            final data = snapshot.requireData;
                                            return ListView.builder(
                                                addAutomaticKeepAlives: false,
                                                addRepaintBoundaries: false,
                                                reverse: true,
                                                itemCount: data.size,
                                                itemBuilder: (context, index) {
                                                  Color c;
                                                  Alignment a;
                                                  print(
                                                      "the other data size is: " +
                                                          data.size.toString());
                                                  if (data.docs[index]
                                                          ['SAdmin'] ==
                                                      false) {
                                                    c = Colors.lightGreen;
                                                    a = Alignment.centerLeft;
                                                  } else {
                                                    c = Colors.blueGrey;
                                                    a = Alignment.centerRight;
                                                  }

                                                  return SizedBox(
                                                      child: Align(
                                                          alignment: a,
                                                          child: Container(
                                                            child: Text(
                                                              '  ${data.docs[index]['Message']}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            constraints:
                                                                const BoxConstraints(
                                                              maxHeight: double
                                                                  .infinity,
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: c,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          35.0),
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                    offset:
                                                                        Offset(0,
                                                                            3),
                                                                    blurRadius:
                                                                        5,
                                                                    color: Colors
                                                                        .grey)
                                                              ],
                                                            ),
                                                          )));
                                                });
                                          })),
                                ],
                              )),

                          //////
                          // This is the reply
                          //////
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Row(
                                children: [
                                  Container(
                                      height: 70,
                                      constraints: const BoxConstraints(
                                        maxHeight: double.infinity,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius:
                                            BorderRadius.circular(35.0),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      margin: const EdgeInsets.all(20.0),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: sentText,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            "Type Something...",
                                                        hintStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .white),
                                                        border:
                                                            InputBorder.none),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.send,
                                                  color: Colors.white),
                                              onPressed: () {
                                                String text = sentText.text;
                                                if (text != '') {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'SOSEmergencies')
                                                      .doc(callerId)
                                                      .collection('messages')
                                                      .add({
                                                    'Message': text,
                                                    'SAdmin': true,
                                                    'time': FieldValue
                                                        .serverTimestamp()
                                                  });
                                                  sentText.text = '';
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      )),
                                ],
                              ))
                        ])
                      ],
                    ),
                  ),
                ]),
                Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.70,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Row(
                      children: [
                        Expanded(child: RTCVideoView(_remoteRenderer!)),
                      ],
                    ),
                  ),
                ])
              ]))
        ]));
  }
}

class StreetMap extends StatelessWidget {
  const StreetMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String htmlId = "8";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = googleMap.LatLng(
          double.parse(latitudePassed!), double.parse(longitudePassed!));

      final mapOptions = googleMap.MapOptions()
        ..zoom = 19
        ..center = myLatlng;

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = googleMap.GMap(elem, mapOptions);

      final marker = googleMap.Marker(googleMap.MarkerOptions()
        ..position = myLatlng
        ..map = map
        ..title = 'caller');

      final infoWindow = googleMap.InfoWindow(
          googleMap.InfoWindowOptions()..content = 'caller');
      marker.onClick.listen((event) => infoWindow.open(map, marker));
      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }
}
