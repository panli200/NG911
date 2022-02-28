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
import 'package:pointycastle/api.dart' as crypto;
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:sos_app/services/encryption.dart';
import 'package:cryptography/cryptography.dart';
import 'package:sos_app/services/connectionStatus.dart';
import 'package:sos_app/sos_extended_pages/ringing_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/routes/router.gr.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sos_app/profile_extended_pages/dialog_widget.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sos_app/services/location.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:sos_app/services/TwentyPoints.dart';
import 'dart:async';
import 'package:path/path.dart';
class SosHomePage extends StatefulWidget {
  SosHomePage({Key? key}) : super(key: key);

  @override
  SosHomePageState createState() => SosHomePageState();
}
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

Future<void> onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  var currentIndex = 0;
  final database = openDatabase(
    join(await getDatabasesPath(), 'sensor_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE sensors(id INTEGER PRIMARY KEY, latitude TEXT, longitude TEXT)',
      );
    },
    version: 1,
  );

  Future<void> insertSensor(Sensor sensor) async {
    // Get a reference to the database.
    final db = await database;

    await db.insert(
      'sensors',
      sensor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Sensor>> sensors() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all sensor.
    final List<Map<String, dynamic>> maps = await db.query('sensors');

    // Convert the List<Map<String, dynamic> into a List<Sensor>.
    return List.generate(maps.length, (i) {
      return Sensor(
        id: maps[i]['id'],
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
      );
    });
  }

  Future<Sensor> sensorItem(index) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all sensor.
    final List<Map<String, dynamic>> maps = await db.query('sensors');

    // Convert the List<Map<String, dynamic> into a List<Sensor>.

    return Sensor(
      id: index,
      latitude: maps[index]['latitude'],
      longitude: maps[index]['longitude'],
    );
  }

  Future<void> updateSensor(Sensor sensor) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given sensor.
    await db.update(
      'sensors',
      sensor.toMap(),
      // Ensure that the sensor has a matching id.
      where: 'id = ?',
      // Pass the sensor's id as a whereArg to prevent SQL injection.
      whereArgs: [sensor.id],
    );
  }

  Future<void> deleteSensor(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the sensor from the database.
    await db.delete(
      'sensors',
      // Use a `where` clause to delete a specific sensor.
      where: 'id = ?',
      // Pass the sensor's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event!["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(seconds: 30), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "SOS App",
      content: "Listening to background",
    );
    Location location = Location();
    await location.getCurrentLocation();
    if (currentIndex < 20) {
      // getting points 0-19
      var point = Sensor(
        id: currentIndex,
        latitude: location.latitude.toString(),
        longitude: location.longitude.toString(),
      );
      await insertSensor(point);

      currentIndex++; // increment current index
    } else {
      // current index is 20 -> first 20 points have been set
      var NewPoint = Sensor(
        id: 19,
        latitude: location.latitude.toString(),
        longitude: location.longitude.toString(),
      );
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('sensors');

      // Convert the List<Map<String, dynamic> into a List<Sensor>.

      for (int i = 0; i < maps.length; i++) {
        // shifting all sensors in i to i-1, from 0-19
        Sensor? sensorPlusOne = await sensorItem(i + 1);
        Sensor overWritten = Sensor(
            id: i,
            latitude: sensorPlusOne!.getLatitude(),
            longitude: sensorPlusOne.getLongitude());
        updateSensor(overWritten);
      }
      updateSensor(NewPoint); // Finally, write the new point to the index 19
    }

    service.sendData(
      {
        "current_lat": location.latitude.toString(),
        "current_long": location.longitude.toString()
      },
    );
  });
}


class SosHomePageState extends State<SosHomePage> {
  //For RSA encryption
  Future<crypto.AsymmetricKeyPair>? futureKeyPair;
  crypto.AsymmetricKeyPair? keyPair;   //to store the KeyPair once we get data from our future
  late var publicKey;
  late var privKey;
  late String publicKeyString;
  late final aesAlgorithm;
  late final aesSecretKey;
  final howToUsePopUp = HowToUseData.howToUsePopUp;
  void Encrypt()async{
    futureKeyPair    =  getKeyPair();
    keyPair          =  await futureKeyPair;
    publicKey =  keyPair!.publicKey;
    privKey   =  keyPair!.privateKey;
    var helper = RsaKeyHelper();
    publicKeyString = helper.encodePublicKeyToPemPKCS1(publicKey);
    aesAlgorithm = AesCtr.with256bits(macAlgorithm: Hmac.sha256());
    aesSecretKey = aesAlgorithm.newSecretKey();
    setState(() {

    });
  }

  void _callNumber(String? date) async {
    // Encryption generate public and private keys

    Location location = Location();
    await location.getCurrentLocation();
    String user = FirebaseAuth.instance.currentUser!.uid.toString();
    String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();

    CollectionReference emergencies= FirebaseFirestore.instance.collection('SOSEmergencies');
    emergencies.doc(mobile).set({
      'Online': false,
      'Phone': mobile,
      'User': user,
      'StartLocation': GeoPoint(location.latitude, location.longitude),
      'StartTime': date,
      'Waiting': true,
    },SetOptions(merge: true));
}

  @override
  void initState(){
    Encrypt();
    
initializeService();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var router = context.router;
    String textBackground = "Start Tracking";

    return Scaffold(
      backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text("SOS"),
          centerTitle: true,
        ),
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new ConnectionStatus(),
          // Container(
          //   height: 40,
          //   width: 40,
          //   child: HowToUseButton(
          //       tileColor: howToUsePopUp.color,
          //       pageTitle: howToUsePopUp.title,
          //       onTileTap: () => context.router.push(
          //             HowToUseRoute(
          //               howToUseID: howToUsePopUp.id,
          //             ),
          //           ) // onTileTap
          //       ),
          // ), // How To Use App Placeholder

          SizedBox(height: 20), // Spacing visuals

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container
              (
                padding: EdgeInsets.all(10.0),
                decoration: 
                  BoxDecoration
                  (
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 1)),
                    child:
                      Column
                      (
                        children: 
                        [
                          Row
                          (
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: 
                            [
                              IconButton
                              (
                                icon: Icon(FlutterRemix.information_fill, color: Colors.amber, size: 30, ),
                                onPressed: () {showTrackingDialogBox(context);}
                              ),

                              Text
                              (
                                'Track Location',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17,),
                              ),
                            ],
                          ),

                          const Divider
                          (
                            height: 5,
                            thickness: 3,
                            color: Colors.black12,
                          ),

                          SizedBox(height: 10), // Spacing visuals

                          Center
                          (
                            child: 
                              Container
                              (
                                child: 
                                  ElevatedButton
                                  (
                                    child: Text(textBackground),
                                    style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.black),),
                                    onPressed: () async { // code here to activate background
                                      final service = FlutterBackgroundService();
                                      var isRunning = await service.isServiceRunning();
                                      if (isRunning) {
                                        service.sendData(
                                          {"action": "stopService"},
                                        );
                                      } else {
                                        service.start();
                                      }

                                      if (!isRunning) {
                                        textBackground = 'Stop Tracking';
                                      } else {
                                        textBackground = 'Start Tracking';
                                      }

                                      setState(() {});
                                    },
                                  )
                              )
                          ),
                        ],
                      )
              ),
              

              SizedBox(height: 10), // Spacing visuals

              Container
              (
                padding: EdgeInsets.all(10.0),
                decoration: 
                  BoxDecoration
                  (
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 1)
                  ),
                child:
                  Column
                  (
                    children: 
                    [
                      Row
                      (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: 
                        [
                          IconButton
                          (
                            icon: Icon(FlutterRemix.information_fill, color: Colors.amber, size: 30, ),
                            onPressed: () {showSOSDialogBox(context);}
                          ),

                          Center
                          (
                            child: 
                            Text
                            (
                              'Connect with 911 for',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ],
                      ),

                      const Divider
                          (
                            height: 5,
                            thickness: 3,
                            color: Colors.black12,
                          ),
                      
                      SizedBox(height: 10), // Spacing visuals

                      Center
                      (
                        child: 
                          Container
                          (
                            child: 
                              ElevatedButton
                              (
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
                                onPressed: () async {
                                  WidgetsFlutterBinding.ensureInitialized();
                                  var now = new DateTime.now();
                                  String? date = now.toString();
                                  _callNumber(date);
                                  updateSensors(date, publicKeyString, aesSecretKey);
                                  sendUserDate(); //TEST calling send the user profile function to send the data to firebase
                                  uploadFile(); //TEST upload files to the firebase storage
                                  updateHistory(); //Test adding call history database
                                  sendLocationHistory(); // send last 10 minutes "or less minutes since started" of location history
                                  sendUpdatedLocation(); // send location on FireBbase each 5 seconds to be accessed on callcontrol page map
                                  personal(); //Test adding call type
                                  router.push(RingingRoute(privateKey: privKey,publicKey: publicKey, aesKey: aesSecretKey));
                                },
                                child: Text("Yourself"),
                              )
                          )
                      ),

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
                          updateSensors(date, publicKeyString, aesSecretKey);
                          sendUserDate(); //TEST calling send the user profile function to send the data to firebase
                          uploadFile(); //TEST upload files to the firebase storage
                          updateHistory(); //Test adding call history database
                          sendLocationHistory();// send last 10 minutes "or less minutes since started" of location history
                          sendUpdatedLocation(); // send location on FireBbase each 5 seconds to be accessed on callcontrol page map
                          contact(); //Test adding call type
                          router.push(RingingRoute(privateKey: privKey,publicKey: publicKey, aesKey: aesSecretKey));
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
                          updateSensors(date, publicKeyString, aesSecretKey);
                          updateHistory(); //Test adding call history database
                          sendLocationHistory();// send last 10 minutes "or less minutes since started" of location history
                          sendUpdatedLocation(); // send location on FireBbase each 5 seconds to be accessed on callcontrol page map
                          standby();
                          router.push(RingingRoute(privateKey: privKey,publicKey: publicKey, aesKey: aesSecretKey));
                        },
                        child: Text("Third Party (Bystander)"),
                      ))),
                    ],
                  )
              )
            ],
          ) // SOS Scenario Button Placeholders
        ],
      ),
    ));
  }
}
