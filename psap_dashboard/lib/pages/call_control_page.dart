// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_web_libraries_in_flutter

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
import 'package:pointycastle/api.dart' as crypto;
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'messages.dart';

// Environmental variables
String? latitudePassed = '';
String? longitudePassed = '';
bool? ended;
late Timer locationTimer;
List<googleMap.LatLng>? previousLocations; // list of location before call
List<googleMap.LatLng>? newLocations; // list of location during the call

class CallControlPanel extends StatefulWidget {
  final CallerId;
  final Snapshot;
  final name;
  final type;
  final publicKey;
  final privateKey;
  const CallControlPanel(
      {Key? key,
        required this.CallerId,
        required this.Snapshot,
        required this.type,
        required this.publicKey,
        required this.privateKey,
        this.name})
      : super(key: key);

  @override
  State<CallControlPanel> createState() => _CallControlPanelState();
}

class _CallControlPanelState extends State<CallControlPanel> {
  // video streaming
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  // For encryption
  Future<crypto.AsymmetricKeyPair>? futureKeyPair;
  crypto.AsymmetricKeyPair?
  keyPair; //to store the KeyPair once we get data from our future
  var publicKey;
  var privKey;
  var otherEndPublicKey;
  late final aesSecretKey;
  late final aesSecretKeyString;
  final algorithm = AesCtr.with256bits(macAlgorithm: Hmac.sha256());

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

  // Listeners
  StreamSubscription? publicKeyStream;
  StreamSubscription? aesKeyStream;
  StreamSubscription? endedStateStream;
  StreamSubscription? startTimeStream;
  StreamSubscription? batteryStream;
  StreamSubscription? longitudeStream;
  StreamSubscription? latitudeStream;
  StreamSubscription? speedStream;
  StreamSubscription? accelerationStream;
  StreamSubscription? roomIdStream;

  // Queries
  Stream<QuerySnapshot>? messages;
  Stream<QuerySnapshot>? locationsHistory;
  Query? sortedPreviousLocation;

  // Chat controller
  final sentText = TextEditingController();

  // Page variables
  var roomId;
  String? startTime;
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
    startTime ??= DateTime.now()
        .toString(); // checking and assessing null date value for start time
    await user.doc(callerId).collection('Emergencies').add({
      'StartTime': startTime,
      'EndTime': FieldValue.serverTimestamp(),
      'EndPointLatitude': latitudePassed,
      'EndPointLongitude': longitudePassed
    });

    // End records messages
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

    // End records new locations
    var collectionNewLocation = FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .collection("NewLocations");
    var snapshotsNewLocation = await collectionNewLocation.get();
    for (var doc in snapshotsNewLocation.docs) {
      await doc.reference.delete();
    }

    // End records rooms
    var collectionRoom = FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .collection("rooms");
    var snapshotsRooms = await collectionRoom.get();
    for (var doc in snapshotsRooms.docs) {
      await doc.reference.delete();
    }

    // Ending the endState stream
    endedStateStream?.cancel();
    dispose();
  }

  void activateListeners() async {
    WidgetsFlutterBinding.ensureInitialized();

    endedStateStream = ref
        .child('sensors')
        .child(callerId)
        .child('Ended')
        .onValue
        .listen((event) async {
      try{
        bool? endedB = event.snapshot.value as bool;
        ended = endedB;
        // ignore: empty_catches
      }catch(e){

      }
    });

    aesKeyStream = ref
        .child('sensors')
        .child(callerId)
        .child('caller_aes_key')
        .onValue
        .listen((event) {
      if (ended != true) {
        try{
          String publicKeyPassed = event.snapshot.value.toString();
          aesSecretKeyString =
              (jsonDecode(publicKeyPassed) as List<dynamic>).cast<int>();
          aesSecretKey = SecretKey(aesSecretKeyString);
          setState(() {});
          // ignore: empty_catches
        }catch(e){

        }
      }
    });

    publicKeyStream = ref
        .child('sensors')
        .child(callerId)
        .child('caller_public_key')
        .onValue
        .listen((event) {
      if (ended != true) {
        try{
          String publicKeyPassed = event.snapshot.value.toString();
          var helper = RsaKeyHelper();
          otherEndPublicKey = helper.parsePublicKeyFromPem(publicKeyPassed);
          setState(() {});
          // ignore: empty_catches
        }catch(e){

        }
      }
    });

    startTimeStream = ref
        .child('sensors')
        .child(callerId)
        .child('StartTime')
        .onValue
        .listen((event) {
      if (ended != true) {
        try {
          setState(() {
            startTime = event.snapshot.value.toString();
          });
          // ignore: empty_catches
        }catch(e){

        }
      }
    });

    batteryStream = ref
        .child('sensors')
        .child(callerId)
        .child('MobileCharge')
        .onValue
        .listen((event) {
      if (ended != true) {
        try{
          String mobileCharge = event.snapshot.value.toString();
          setState(() {
            mobileChargeString = 'Mobile Charge: ' + mobileCharge;
          });
          // ignore: empty_catches
        }catch(e){

        }
      }
    });

    speedStream = ref
        .child('sensors')
        .child(callerId)
        .child('Speed')
        .onValue
        .listen((event) {
      if (ended != true) {
        try{
          String speed = event.snapshot.value.toString();
          setState(() {
            speedString = speed;
          });
          // ignore: empty_catches
        }catch(e){

        }
      }
    });

    accelerationStream = ref
        .child('sensors')
        .child(callerId)
        .child('Acceleration')
        .onValue
        .listen((event) {
      if (ended != true) {
        try{
          String accelerationValue = event.snapshot.value.toString();
          setState(() {
            AccelerationString = accelerationValue;
          });
          // ignore: empty_catches
        }catch(e){

        }
      }
    });

    roomIdStream = ref
        .child('sensors')
        .child(callerId)
        .child('RoomID')
        .onValue
        .listen((event) {
      if (ended != true) {
        setState(() {
          roomId = event.snapshot.value.toString();
          if (roomId != null) {
            signaling.joinRoom(
                roomId, _remoteRenderer, callerId); //join the video stream
          }
        });
      }
    });
  }

  Future<void> getStartLocation() async {
    var collection = FirebaseFirestore.instance.collection('SOSEmergencies');
    var docSnapshot = await collection.doc(callerId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      startLan = data['StartLocation'].latitude.toString();
      startLon = data['StartLocation'].longitude.toString();
      //Get route before the call
      previousLocations = [
        googleMap.LatLng(double.parse(startLan), double.parse(startLon))
      ];
    }
    // Get weather info
    WeatherFactory wf = WeatherFactory("5e1ad24d143d638f46a53ae6403ee651");
    Weather w = await wf.currentWeatherByLocation(
        double.parse(startLan), double.parse(startLon));
    setState(() {
      weatherDescription = w.weatherDescription!;
      humidity = w.humidity!;
      windSpeed = w.windSpeed!;
      temperature = w.temperature!.celsius!.toInt();
    });
  }

  Future<void> getLocationHistory() async {
    Query sortedPreviousLocation = FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .collection('location')
        .orderBy("id", descending: true);
    QuerySnapshot queryPreviousLocation = await sortedPreviousLocation.get();
    List previousLocationsFetched =
    queryPreviousLocation.docs.map((doc) => doc.data()).toList();
    for (int i = previousLocationsFetched.length - 1; i > 0; i--) {
      double? latitude = 0;
      double? longitude = 0;
      if (double.tryParse(previousLocationsFetched[i]['Latitude']) != null &&
          double.tryParse(previousLocationsFetched[i]['Longitude']) != null) {
        latitude = double.tryParse(previousLocationsFetched[i]['Latitude']);
        longitude = double.tryParse(previousLocationsFetched[i]['Longitude']);
        setState(() {
          previousLocations!.add(googleMap.LatLng(latitude, longitude));
        });
      }
    }
  }

  // Initialize
  @override
  void initState() {
    ended = false;
    // Video streaming
    _remoteRenderer.initialize();
    _localRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    signaling.openUserMedia(_localRenderer, _remoteRenderer);

    privKey = widget.privateKey;
    publicKey = widget.publicKey;
    callerId = widget.CallerId; //Getting user ID from the previous page..
    name = widget.name;
    callType = widget.type;
    FbDb.DatabaseReference ref = FbDb.FirebaseDatabase.instance.ref();
    final databaseReal = ref.child('sensors').child(callerId);
    databaseReal.update({
      'dispatcher_public_key': publicKey,
    });

    ref.child('sensors').child(callerId).update({'Online': true});

    //messages
    final Query sortedMessages = FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .collection('messages')
        .orderBy("time", descending: true);
    messages = sortedMessages.snapshots();

    //new location read by order of id
    locationsHistory = FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(callerId)
        .collection('NewLocations')
        .orderBy("id")
        .snapshots();

    activateListeners();

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
    getLocationHistory();
    super.initState();
  }

  @override
  void dispose() async {
    // clean video streaming
    _localRenderer.dispose();
    _remoteRenderer.dispose();

    publicKeyStream!.cancel();
    aesKeyStream!.cancel();
    startTimeStream!.cancel();
    batteryStream!.cancel();
    longitudeStream!.cancel();
    latitudeStream!.cancel();
    speedStream!.cancel();
    accelerationStream!.cancel();
    roomIdStream!.cancel();
    newLocations!.clear();
    previousLocations!.clear();
    FbDb.DatabaseReference real = FbDb.FirebaseDatabase.instance.ref();
    final databaseReal = real.child('sensors').child(callerId);
    databaseReal.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Message> messagesList = [];

    /// Encrypt and sent to database
    void encryptTextAndSend(String text) async {
      // message to bytes
      var message = utf8.encode(text);
      // secret box
      final secretBox = await algorithm.encrypt(
        message,
        secretKey: await aesSecretKey,
      );
      // send secret box attributes
      String nonce = secretBox.nonce.toString();
      String cipher = secretBox.cipherText.toString();
      String mac = secretBox.mac.bytes.toString();
      FirebaseFirestore.instance
          .collection('SOSEmergencies')
          .doc(callerId)
          .collection('messages')
          .add({
        'SAdmin': true,
        'time': FieldValue.serverTimestamp(),
        'nonce': nonce,
        'cipher': cipher,
        'mac': mac
      });
    }

    String? userMotion = '';
    double? speedDouble = 0.0;
    Future.delayed(Duration.zero, () async {
      emergencyContactNumberString = await getEmergencyContactNumber(callerId);
      emergencyHealthCardNumberString =
      await getEmergencyContactHealthCard(callerId);
      personalHealthCardString = await getPersonalHealthCard(callerId);
      urlPMR = await getUrlPMR(callerId);
      // ignore: unnecessary_null_comparison
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
                            height:
                            MediaQuery.of(context).size.height * 0.74,
                            width: MediaQuery.of(context).size.width * 0.43,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.white, width: 1)),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: locationsHistory,
                                builder: (
                                    BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot,
                                    ) {
                                  if (snapshot.hasError) {
                                    return Text(
                                        'Something went wrong  ${snapshot.error}');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text('Loading');
                                  }
                                  final data = snapshot.requireData;

                                  //Initial the new locations list
                                  double? startLatitudePassed =
                                  double.tryParse(startLan);
                                  double? startLongitudePassed =
                                  double.tryParse(startLon);
                                  if (startLatitudePassed != null &&
                                      startLongitudePassed != null) {
                                    newLocations = [
                                      googleMap.LatLng(startLatitudePassed,
                                          startLongitudePassed)
                                    ];
                                  }

                                  //Adding the location to
                                  for (int i = 0;
                                  i < data.docs.length;
                                  i++) {
                                    double? latitudeNew = double.tryParse(
                                        data.docs[i]['latitude']);
                                    double? longitudeNew = double.tryParse(
                                        data.docs[i]['longitude']);

                                    if (latitudeNew != null &&
                                        longitudeNew != null) {
                                      newLocations!.add(googleMap.LatLng(
                                          latitudeNew, longitudeNew));
                                    }
                                  }

                                  return StreetMap();
                                }))
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
                                    signaling.hangUp(roomId, callerId);
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
                          MediaQuery.of(context).size.height * 0.44,
                          width:
                          MediaQuery.of(context).size.width * 0.25,
                          padding: const EdgeInsets.all(10.0),
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
                              SingleChildScrollView(
                                child: Column(
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
                                        const Icon(FlutterRemix
                                            .battery_2_charge_line),
                                        Text(
                                          mobileChargeString,
                                          style:
                                          const TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(FlutterRemix
                                            .smartphone_line),
                                        Text(
                                          'Phone: ${snapshot['Phone']}',
                                          style:
                                          const TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                            FlutterRemix.celsius_line),
                                        Text(
                                          'Weather: ' +
                                              temperature!.toString() +
                                              '° ' +
                                              weatherDescription!,
                                          style:
                                          const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(FlutterRemix
                                            .contrast_drop_2_line),
                                        Text(
                                          'Humidity: ' +
                                              humidity!.toString(),
                                          style: const TextStyle(
                                              fontSize: 15),
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
                                          style: const TextStyle(
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: const [
                                        Icon(FlutterRemix.map_pin_line),
                                        Text(
                                          'Location of the call: ———',
                                          style:
                                          TextStyle(fontSize: 15),
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
                                      children: [
                                        Text(
                                          'Caller is' + userMotion!,
                                          style: const TextStyle(
                                              fontSize: 15),
                                        ),
                                        const Icon(
                                            FlutterRemix.walk_fill),
                                        Text(
                                          userMotion!,
                                          style: const TextStyle(
                                              fontSize: 15),
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
                                  ],
                                ),
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
                                            // This is the chat
                                            SizedBox(
                                                height: MediaQuery.of(
                                                    context)
                                                    .size
                                                    .height *
                                                    0.29,
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
                                                                  itemCount: data.size,
                                                                  shrinkWrap: true,
                                                                  reverse: false,
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
                                                                      // dispatcher
                                                                      c = Colors.blue;
                                                                      a = Alignment.centerRight;
                                                                    }

                                                                    var nonceString =
                                                                    data.docs[index]['nonce'];
                                                                    var cipherString =
                                                                    data.docs[index]['cipher'];
                                                                    var macString =
                                                                    data.docs[index]['mac'];

                                                                    var macBytes =
                                                                    (jsonDecode(macString) as List<dynamic>).cast<int>();
                                                                    Mac macFinal =
                                                                    Mac(macBytes);
                                                                    List<int>
                                                                    nonceInt =
                                                                    (jsonDecode(nonceString) as List<dynamic>).cast<int>();
                                                                    List<int>
                                                                    cipherInt =
                                                                    (jsonDecode(cipherString) as List<dynamic>).cast<int>();
                                                                    SecretBox
                                                                    newBox =
                                                                    SecretBox(cipherInt, nonce: nonceInt, mac: macFinal);
                                                                    messagesList.add(Message(
                                                                        secretBox: newBox,
                                                                        aesSecretKey: aesSecretKey,
                                                                        alignment: a,
                                                                        color: c));
                                                                    return messagesList[index];
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
                                                    encryptTextAndSend(
                                                        text);
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

class StreetMap extends StatefulWidget {
  StreetMap({Key? key}) : super(key: key);

  @override
  State<StreetMap> createState() => _StreetMapState();
}

class _StreetMapState extends State<StreetMap> {
  var mapOptions = googleMap.MapOptions();

  late var map;
  late var elem = DivElement();
  late List<googleMap.LatLng> newLocationsPassed;
  List<googleMap.LatLng> starterNewListNullExclusion = [
    googleMap.LatLng(50.4182278, -104.594109)
  ];
  late var myLatlng;
  var lineNew = googleMap.Polyline();
  var line = googleMap.Polyline();
  var marker = googleMap.Marker();
  void refresh() {
    Timer.periodic(const Duration(seconds: 5), (locationTimer) async {
      if (ended != true) {
        newLocationsPassed = newLocations!;
        googleMap.LatLng Latest = newLocationsPassed!.last;
        setState(() {
          mapOptions..center = Latest;
          map = googleMap.GMap(elem, mapOptions);
          lineNew..path = newLocationsPassed;
          lineNew..map = map;
          line..map = map;
          marker..position = Latest;
          marker..map = map;
        });
      }
      if (ended == true) {
        newLocationsPassed.clear();
        //  locationTimer.cancel();
        // dispose();
      }
    });
  }

  @override
  void initState() {
    if (newLocations != null) {
      newLocationsPassed = newLocations!;
    } else {
      newLocationsPassed = starterNewListNullExclusion;
    }
    refresh();
    try{
      myLatlng = previousLocations![0];
      // ignore: empty_catches
    } catch(e){

    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String htmlId = "8";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final policeLatLng = googleMap.LatLng(50.4182278, -104.594109);

      mapOptions = googleMap.MapOptions()
        ..zoom = 19
        ..center = myLatlng;

      elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      map = googleMap.GMap(elem, mapOptions);

      final policeMarker = googleMap.Marker(googleMap.MarkerOptions()
        ..position = policeLatLng
        ..map = map
        ..icon = 'https://maps.google.com/mapfiles/ms/icons/police.png');

      marker = googleMap.Marker(googleMap.MarkerOptions()
        ..position = myLatlng
        ..map = map
        ..title = 'caller');

      line = googleMap.Polyline(googleMap.PolylineOptions()
        ..map = map
        ..path = previousLocations);

      lineNew = googleMap.Polyline(googleMap.PolylineOptions()
        ..map = map
        ..path = newLocationsPassed
        ..strokeColor = "#c4161b");

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }
}