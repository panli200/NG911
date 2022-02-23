import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/annotations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:path/path.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:sos_app/profile_extended_pages/sos_user.dart';
import 'package:sos_app/profile_extended_pages/dialog_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_app/profile_extended_pages/sliding_switch_widget.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sos_app/services/location.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sos_app/services/TwentyPoints.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  _ProfilePageState createState() => _ProfilePageState();
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

class _ProfilePageState extends State<ProfilePage> {
  File? file, fileT;
  PhoneContact? _phoneContact;
  TextEditingController ctlHealthCard = TextEditingController();
  TextEditingController ctlHealthCard2 = TextEditingController();
  bool sw1 = false;
  bool sw2 = false;
  bool sw3 = false;
  SOSUser _user = SOSUser();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  String textBackground = "Start Service";
  getGeneralValue() async {
    prefs = await _prefs;

    setState(() {
      _user.generalPermission = (prefs.containsKey("GeneralPermission")
          ? prefs.getBool("GeneralPermission")
          : false)!;

      _user.contactNum =
          (prefs.containsKey("Contact") ? prefs.getString("Contact") : '')!;
    });
  }

  getMedicalValue() async {
    prefs = await _prefs;

    setState(() {
      _user.personalMedicalPermission =
          (prefs.containsKey("PersonalMedicalPermission")
              ? prefs.getBool("PersonalMedicalPermission")
              : false)!;
      _user.personalHealthNum =
          (prefs.containsKey("HealthNum") ? prefs.getString("HealthNum") : '')!;
      _user.personalMedicalFile = (prefs.containsKey("PersonalFile")
          ? prefs.getString("PersonalFile")
          : '')!;
      _user.contactMedicalPermission =
          (prefs.containsKey("contactMedicalPermission")
              ? prefs.getBool("contactMedicalPermission")
              : false)!;
      _user.contactHealthNum = (prefs.containsKey("ContactHealthNum")
          ? prefs.getString("ContactHealthNum")
          : '')!;
      _user.contactMedicalFile = (prefs.containsKey("ContactFile")
          ? prefs.getString("ContactFile")
          : '')!;
    });
  }

  saveGeneralValue() async {
    prefs.setBool("GeneralPermission", _user.generalPermission);
    prefs.setString("Contact", _user.contactNum);
  }

  saveMedicalValue() async {
    prefs.setBool("PersonalMedicalPermission", _user.personalMedicalPermission);
    prefs.setString("HealthNum", _user.personalHealthNum);
    prefs.setString("PersonalFile", _user.personalMedicalFile);
    prefs.setString("PersonalFilePath", _user.personalMedicalFilePath);
    prefs.setBool("contactMedicalPermission", _user.contactMedicalPermission);
    prefs.setString("ContactHealthNum", _user.contactHealthNum);
    prefs.setString("ContactFile", _user.contactMedicalFile);
    prefs.setString("ContactFilePath", _user.contactMedicalFilePath);
  }

  void initState() {
    initializeService();
    super.initState();
    getGeneralValue();
    getMedicalValue();
  }

  void dispose() {
    ctlHealthCard.dispose();
    ctlHealthCard2.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(
                          FlutterRemix.information_fill,
                          color: Colors.amber,
                          size: 30,
                        ),
                        onPressed: () {
                          showGeneralDialogBox(context);
                        }),
                    Text(
                      'General Information',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Text(
                      'Permission to Share: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SlidingSwitchWidget(
                      choice: false,
                      onClicked: (bool systemOverlaysAreVisible) async {
                        sw1 = systemOverlaysAreVisible;
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 24.0,
                ),
                Row(
                  children: [
                    Text(
                      'Full Legal Name: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Bugs Capstone ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Text(
                      'Emergency Contact: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        _user.contactNum,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        FlutterRemix.user_add_fill,
                        color: Colors.teal,
                        size: 26,
                      ),
                      onPressed: () async {
                        final PhoneContact contact =
                            await FlutterContactPicker.pickPhoneContact();
                        setState(() {
                          _phoneContact = contact;
                          _user.contactNum = (_phoneContact != null
                              ? _phoneContact!.phoneNumber!.number
                              : '')!;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        FlutterRemix.user_unfollow_fill,
                        color: Colors.red,
                        size: 26,
                      ),
                      onPressed: () async {
                        setState(() {
                          _phoneContact = null;
                          _user.contactNum = '';
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  //EDIT GENERAL INFORMATION DIALOG
                  onPressed: () {
                    setState(() {
                      _user.generalPermission = sw1;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Edit General Information'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Text('Permission: '),
                              Text(
                                checkPermission(_user.generalPermission),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              const Text('Emergency Contact: '),
                              Text(
                                _user.contactNum,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              saveGeneralValue();
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('SAVE GENERAL INFORMATION'),
                ),
                SizedBox(
                  height: 16.0,
                ),
                const Divider(
                  height: 10,
                  thickness: 5,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(
                          FlutterRemix.information_fill,
                          color: Colors.amber,
                          size: 30,
                        ),
                        onPressed: () {
                          showMedicalDialogBox(context);
                        }),
                    Text(
                      'Medical Information',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Personal ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Text(
                      'Permission to Share: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SlidingSwitchWidget(
                      choice: false,
                      onClicked: (bool systemOverlaysAreVisible) async {
                        sw2 = systemOverlaysAreVisible;
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Text(
                      'Health Card No: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.length >= 1 && value!.length <= 8) {
                            return 'Please enter 9 digital';
                          }
                          return null;
                        },
                        maxLength: 9,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                        decoration: const InputDecoration(
                          labelText: '9 digital ',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        controller: ctlHealthCard,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Text(
                      'Medical History: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        _user.personalMedicalFile,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        FlutterRemix.attachment_2,
                        color: Colors.teal,
                        size: 26,
                      ),
                      onPressed: () async {
                        setState(() {
                          selectFile();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        FlutterRemix.delete_bin_2_fill,
                        color: Colors.red,
                        size: 26,
                      ),
                      onPressed: () async {
                        setState(() {
                          file = null;
                          _user.personalMedicalFile = ''; // File is null
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 18.0,
                ),
                Text(
                  'Emergency Contact',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Text(
                      'Permission to Share: ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SlidingSwitchWidget(
                      choice: false,
                      onClicked: (bool systemOverlaysAreVisible) async {
                        sw3 = systemOverlaysAreVisible;
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Text(
                      'Health Card No: ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.length >= 1 && value!.length <= 8) {
                            return 'Please enter 9 digital';
                          }
                          return null;
                        },
                        maxLength: 9,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                        decoration: const InputDecoration(
                          labelText: '9 digital ',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        controller: ctlHealthCard2,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Text(
                      'Medical History: ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _user.contactMedicalFile,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        FlutterRemix.attachment_2,
                        color: Colors.teal,
                        size: 26,
                      ),
                      onPressed: () async {
                        setState(() {
                          selectFileT();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        FlutterRemix.delete_bin_2_fill,
                        color: Colors.red,
                        size: 26,
                      ),
                      onPressed: () async {
                        setState(() {
                          fileT = null;
                          _user.contactMedicalFile = ''; // File is null
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _user.personalHealthNum = ctlHealthCard.text;
                        _user.contactHealthNum = ctlHealthCard2.text;
                        _user.personalMedicalPermission = sw2;
                        _user.contactMedicalPermission = sw3;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Edit Medical Information'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const Text('Personal Permission: '),
                                Text(
                                  checkPermission(_user.personalMedicalPermission),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                const Text('Personal Health Card No:'),
                                Text(
                                  _user.personalHealthNum,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                const Text('Personal Medical History:'),
                                Text(
                                  _user.personalMedicalFile,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                const Text('Emergency Contact Permission: '),
                                Text(
                                  checkPermission(_user.contactMedicalPermission),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                const Text('Emergency Contact Health Card No:'),
                                Text(
                                  _user.contactHealthNum,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                const Text(
                                    'Emergency Contact Medical History:'),
                                Text(
                                  _user.contactMedicalFile,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                saveMedicalValue();
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('SAVE MEDICAL INFORMATION'),
                ),
                SizedBox(
                  height: 16.0,
                ),
                const Divider(
                  height: 10,
                  thickness: 5,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  'Background Location Listener',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  child: Text(textBackground),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () async {
                    // code here to activate background

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
                      textBackground = 'Stop Service';
                    } else {
                      textBackground = 'Start Service';
                    }

                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //function for select file
  Future selectFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));

    _user.personalMedicalFile = file != null ? basename(file!.path) : '';
    _user.personalMedicalFilePath = path;
  }

  Future selectFileT() async {
    final result2 = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result2 == null) return;
    final path2 = result2.files.single.path!;

    setState(() => fileT = File(path2));

    _user.contactMedicalFile = fileT != null ? basename(fileT!.path) : '';
    _user.contactMedicalFilePath = path2;
  }

  //function for check the permission
  String checkPermission(permission) {
    if (permission == true)
      return "Given";
    else
      return "Not Given";
  }
}

// Sensor class for location
