import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as FbDb;
import 'package:flutter_remix/flutter_remix.dart';
import 'package:weather/weather.dart';
import 'dart:async';
import 'maps_home_page.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'signaling.dart';
import 'package:google_maps/google_maps.dart' as googleMap;
import 'dart:ui' as ui;
import 'dart:html';
import 'health__info_buttons.dart';
import 'user_data_page.dart';
import 'location.dart';
import 'package:flutter_remix/flutter_remix.dart';

// Enviromental variables
String? latitudePassed = '';
String? longitudePassed = '';

List<googleMap.LatLng>? previousLocs ;

class CallControlPanel extends StatefulWidget {
  final CallerId;
  final Snapshot;
  final signaling;
  final remoteRenderer;
  final localRenderer;
  final name;
  final type;
  const CallControlPanel(
      {Key? key,
      required this.CallerId,
      required this.Snapshot,
      required this.type,
      required this.signaling,
      required this.localRenderer,
      this.remoteRenderer,
      this.name})
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
  var startLan = '';
  var startLon = '';
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
  String? speedString = ''; // In meters/second

  // other sensors
  String mobileChargeString = '';

  //Video Audio Stream
  Signaling? signaling;
  RTCVideoRenderer? _localRenderer;
  RTCVideoRenderer? _remoteRenderer;

  // Listeners
  StreamSubscription? endedStateStream;
  StreamSubscription? startTimeStream;
  StreamSubscription? batteryStream;
  StreamSubscription? longitudeStream;
  StreamSubscription? latitudeStream;
  StreamSubscription? speedStream;
  StreamSubscription? AccelerationStream;
  StreamSubscription? roomIdStream;

  Stream<QuerySnapshot>? messages;
  String? StartTime;
  final sentText = TextEditingController();

  var roomId;
  String name = '';
  int callType = 4;
  String emergencyContactNumberString = '';
  String emergencyHealthCardNumberString = '';
  String personalHealthCardString = '';
  String urlPMR = '';
  String urlECMR = '';
  // Function to end the call
  void _EndCall() async {
    // Closing the listeners
    startTimeStream?.cancel();
    batteryStream?.cancel();
    longitudeStream?.cancel();
    latitudeStream?.cancel();
    speedStream?.cancel();
    roomIdStream?.cancel();

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

    // End records location
    var collectionLocation = FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .collection("location");
    var snapshotsLocation = await collectionLocation.get();
    for (var doc in snapshotsLocation.docs) {
      await doc.reference.delete();
    }
    // Ending the endState stream
    endedStateStream?.cancel();
  }

  void activateListeners() async {
    WidgetsFlutterBinding.ensureInitialized();
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
          speedString = speed;
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
          AccelerationString = AccelerationValue;
        });
      }
    });
  }

  Future<void> getRoomId() async {
    roomIdStream = ref
        .child('sensors')
        .child(callerId)
        .child('RoomID')
        .onValue
        .listen((event) {
      setState(() {
        roomId = event.snapshot.value.toString();
        signaling = widget.signaling;
        _localRenderer = widget.localRenderer;
        _remoteRenderer = widget.remoteRenderer;

        signaling?.joinRoom(
            roomId, _remoteRenderer!, callerId); //join the video stream
      });
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

  Future<void> getStartLocation() async {
    var collection = FirebaseFirestore.instance.collection('SOSEmergencies');
    var docSnapshot = await collection.doc(callerId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      startLan = data['StartLocation'].latitude.toString();
      startLon = data['StartLocation'].longitude.toString();
      //Get route before the call
      previousLocs = [
        googleMap.LatLng(double.parse(startLan), double.parse(startLon))
      ];
      // fetch the locations and add it to list at here:


      //Get the route after the call
      // List<googleMap.LatLng> newLocs = [
      //   googleMap.LatLng(double.parse(startLan), double.parse(startLon))
      // ];
    }
    print("-------------");
    print(previousLocs);
    var locSnapshot = await collection.doc(callerId).collection('location').get();


  }

  // Initialize
  @override
  void initState() {
    callerId = widget.CallerId; //Getting user ID from the previous page..
    name = widget.name;
    callType = widget.type;

    // Get Locaiton list Stream
//    Location? streamLoc = Location(callerId);
//    double? LatitudeStreamed = 0.0;
//    streamLoc.streamLatitude.listen((event) {
//      LatitudeStreamed = event;
//    });
//    double? LongitudeStreamed = 0.0;
//    streamLoc.streamLongitude.listen((event) {
//      LongitudeStreamed = event;
//    });
    getRoomId(); //get roomId and join the stream

    ref.child('sensors').child(callerId).update({'Online': true});

    //messages
    final Query sortedMessages = FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .collection('messages')
        .orderBy("time", descending: true);
    messages = sortedMessages.snapshots();

    activateListeners();
    getLocationWeather();
//    initialize Widgets

    // Changing states
    snapshot = widget.Snapshot;
    FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .update({
      'Waiting': false,
      'Online': true
    }); // Changing the caller's Waiting state to be False and Online state to be True

    getStartLocation();
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
    String? userMotion = '';
    double? speedDouble = 0.0;
    Future.delayed(Duration.zero, () async {
      emergencyContactNumberString = await getEmergencyContactNumber(callerId);
      emergencyHealthCardNumberString =
          await getEmergencyContactHealthCard(callerId);
      personalHealthCardString = await getPersonalHealthCard(callerId);
      urlPMR = await getUrlPMR(callerId);
      urlECMR = await getUrlECMR(callerId);
      setState(() {});
      if (double.tryParse('$speedString') != null) {
        WidgetsFlutterBinding.ensureInitialized();
        speedDouble = double.tryParse('$speedString');
        if (speedDouble! >= 1.0 || speedDouble! <= -1.0) {
          userMotion = 'moving';
          setState(() {});
        } else {
          userMotion = 'still';
          setState(() {});
        }
      } else {
        WidgetsFlutterBinding.ensureInitialized();
        userMotion = 'unknown';
        setState(() {});
      }
    });
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Emergency Control Panel"),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox // First Column (Contains Map and End Call Button)
                  (
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Row(children: <Widget>[
                        Column(children: <Widget>[
                          Row //THE MAP
                              (children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * 0.74,
                              width: MediaQuery.of(context).size.width * 0.43,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.white, width: 1)),
                              child: StreetMap(),
                            )
                          ]),
                          SizedBox // SPACING
                              (
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.25,
                          ),
                          Row //END CONNECTION BUTTON
                              (
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: ElevatedButton(
                                      child: const Text("End Connection"),
                                      onPressed: () async {
                                        signaling!.hangUp(
                                            _localRenderer!, roomId, callerId);
                                        FbDb.DatabaseReference real = FbDb
                                            .FirebaseDatabase.instance
                                            .ref();
                                        final databaseReal = real
                                            .child('sensors')
                                            .child(callerId);

                                        await databaseReal.update(
                                            {'Online': false, 'Ended': true});

                                        // End the call
                                        _EndCall();

                                        // Going back to maps home page
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MapsHomePage(
                                                      name: name,
                                                    )));
                                        // this will the method for your rejected Button
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      )),
                                )
                              ])
                        ]),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Column(children: [
                          Container // Second Column (Contains the user info and chat box)
                              (
                                  height:
                                      MediaQuery.of(context).size.height * 0.45,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white, width: 1)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Caller Information',
                                            style: TextStyle(fontSize: 25),
                                            textAlign: TextAlign.center,
                                          ),
                                          Row(
                                            children: [
                                              Icon(FlutterRemix
                                                  .battery_2_charge_line),
                                              Text(
                                                mobileChargeString,
                                                style: TextStyle(fontSize: 15),
                                              )
                                            ],
                                          ),

                                          Row(
                                            children: [
                                              Icon(
                                                  FlutterRemix.smartphone_line),
                                              Text(
                                                'Phone: ${snapshot['Phone']}',
                                                style: TextStyle(fontSize: 15),
                                              )
                                            ],
                                          ),

                                          Row(
                                            children: [
                                              Icon(FlutterRemix.celsius_line),
                                              Text(
                                                'Weather: ' +
                                                    temperature!.toString() +
                                                    '° ' +
                                                    weatherDescription!,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),

                                          Row(
                                            children: [
                                              Icon(FlutterRemix
                                                  .contrast_drop_2_line),
                                              Text(
                                                'Humidity: ' +
                                                    humidity!.toString(),
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),

                                          Row(
                                            children: [
                                              const Icon(
                                                  FlutterRemix.windy_line),
                                              Text(
                                                'Wind Speed: ' +
                                                    windSpeed!.toString(),
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),

                                          Row(
                                            children: const [
                                              Icon(FlutterRemix.map_pin_line),
                                              Text(
                                                'Location of the call: ———',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Latitude: ' + startLan + '°',
                                          ),
                                          Text(
                                            'Longitude: ' + startLon + '°',
                                          ),
                                          Row(
                                            children: const [
                                              Icon(FlutterRemix
                                                  .user_location_line),
                                              Text(
                                                'Location of the caller now:',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '$latitudeString' + '°',
                                          ),
                                          Text(
                                            '$longitudeString' + '°',
                                          ),

                                          Row(
                                            children: [
                                              Text(
                                                'Caller is' + userMotion!,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Icon(FlutterRemix.walk_fill),
                                              Text(
                                                userMotion!,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          CaseBasic(
                                              type: callType,
                                              phone: callerId,
                                              emergencyContactNumberString:
                                                  emergencyContactNumberString,
                                              emergencyHealthCardNumberString:
                                                  emergencyHealthCardNumberString,
                                              personalHealthCardString:
                                                  personalHealthCardString,
                                              urlPMR: urlPMR,
                                              urlECMR: urlECMR),

                                          // Row
                                          // (
                                          //   children:
                                          //   [
                                          //     Text
                                          //     (
                                          //       '$AccelerationString',
                                          //       style: TextStyle(fontSize: 15),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ],
                                  )),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ), // SPACING

                          Container // CHAT BOX
                              (
                                  height:
                                      MediaQuery.of(context).size.height * 0.44,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white, width: 1)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox // SMS Area
                                                (
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.28,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.24,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    //////
                                                    // This is the chat
                                                    //////
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.31,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.24,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                                child: StreamBuilder<
                                                                        QuerySnapshot>(
                                                                    stream:
                                                                        messages,
                                                                    builder: (
                                                                      BuildContext
                                                                          context,
                                                                      AsyncSnapshot<
                                                                              QuerySnapshot>
                                                                          snapshot,
                                                                    ) {
                                                                      if (snapshot
                                                                          .hasError) {
                                                                        return const Text(
                                                                            'Something went wrong');
                                                                      }

                                                                      if (snapshot
                                                                              .connectionState ==
                                                                          ConnectionState
                                                                              .waiting) {
                                                                        return const Text(
                                                                            'Loading');
                                                                      }

                                                                      final data =
                                                                          snapshot
                                                                              .requireData;

                                                                      return ListView.builder(
                                                                          addAutomaticKeepAlives: false,
                                                                          addRepaintBoundaries: false,
                                                                          reverse: true,
                                                                          itemCount: data.size,
                                                                          itemBuilder: (context, index) {
                                                                            Color
                                                                                c;
                                                                            Alignment
                                                                                a;
                                                                            if (data.docs[index]['SAdmin'] ==
                                                                                false) {
                                                                              c = Colors.black38;
                                                                              a = Alignment.centerLeft;
                                                                            } else {
                                                                              c = Colors.blue;
                                                                              a = Alignment.centerRight;
                                                                            }

                                                                            return SizedBox(
                                                                                child: Align(
                                                                                    alignment: a,
                                                                                    child: Container(
                                                                                      child: Text(
                                                                                        '${data.docs[index]['Message']}',
                                                                                        style: const TextStyle(color: Colors.white),
                                                                                      ),
                                                                                      constraints: const BoxConstraints(
                                                                                        maxHeight: double.infinity,
                                                                                      ),
                                                                                      padding: const EdgeInsets.all(10.0),
                                                                                      margin: const EdgeInsets.all(10.0),
                                                                                      decoration: BoxDecoration(
                                                                                        color: c,
                                                                                        borderRadius: BorderRadius.circular(35.0),
                                                                                        boxShadow: const [
                                                                                          BoxShadow(offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                                                                                        ],
                                                                                      ),
                                                                                    )));
                                                                          });
                                                                    })),
                                                          ],
                                                        )),
                                                  ]),
                                            ),
                                            Container // Reply button area
                                                (
                                                    height: 70,
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxHeight:
                                                          double.infinity,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              35.0),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    margin:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.20,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: TextField(
                                                              controller:
                                                                  sentText,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              decoration: const InputDecoration(
                                                                  hintText:
                                                                      "Type Something...",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                                FlutterRemix
                                                                    .send_plane_fill,
                                                                color: Colors
                                                                    .blue),
                                                            onPressed: () {
                                                              String text =
                                                                  sentText.text;
                                                              if (text != '') {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'SOSEmergencies')
                                                                    .doc(
                                                                        callerId)
                                                                    .collection(
                                                                        'messages')
                                                                    .add({
                                                                  'Message':
                                                                      text,
                                                                  'SAdmin':
                                                                      true,
                                                                  'time': FieldValue
                                                                      .serverTimestamp()
                                                                });
                                                                sentText.text =
                                                                    '';
                                                              }
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                          ],
                                        ),
                                      ])),
                        ]),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Column // VIDEO COLUMN
                            (children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.90,
                            width: MediaQuery.of(context).size.width * 0.30,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.white, width: 1)),
                            child: Row(
                              children: [
                                Expanded(child: RTCVideoView(_remoteRenderer!)),
                              ],
                            ),
                          ),
                        ]),
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
          double.tryParse(latitudePassed!), double.tryParse(longitudePassed!));

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

      final line = googleMap.Polyline(googleMap.PolylineOptions()
        ..map = map
        ..path = previousLocs);

      // final lineNew = googleMap.Polyline(googleMap.PolylineOptions()
      //   ..map = map
      //   ..path = newLocs
      //   ..strokeColor = "#c4161b"
      // );

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }
}
