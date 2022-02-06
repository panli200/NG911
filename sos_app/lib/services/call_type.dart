import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_app/profile_extended_pages/sos_user.dart';

void personal() async {
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  SOSUser user = SOSUser();
  prefs = await _prefs;
  CollectionReference emergency =
      FirebaseFirestore.instance.collection('SOSEmergencies');

  user.generalPermission = (prefs.containsKey("GeneralPermission")
      ? prefs.getBool("GeneralPermission")
      : false)!;

  user.personalMedicalPermission =
      (prefs.containsKey("PersonalMedicalPermission")
          ? prefs.getBool("PersonalMedicalPermission")
          : false)!;

  if ((user.generalPermission == true) &&
      (user.personalMedicalPermission == false)) {
    await emergency
        .doc(mobile)
        .update({
          'type': 1,
        })
        .then((value) => print("Call type Updated"))
        .catchError((error) => print("Failed to add type: $error"));
  } else if ((user.generalPermission == true) &&
      (user.personalMedicalPermission == true)) {
    await emergency
        .doc(mobile)
        .update({
          'type': 2,
        })
        .then((value) => print("Call type Updated"))
        .catchError((error) => print("Failed to add type: $error"));
  } else if ((user.generalPermission == false) &&
      (user.personalMedicalPermission == true)) {
    await emergency
        .doc(mobile)
        .update({
          'type': 3,
        })
        .then((value) => print("Call type Updated"))
        .catchError((error) => print("Failed to add type: $error"));
  } else {
    await emergency
        .doc(mobile)
        .update({
          'type': 5,
        })
        .then((value) => print("Call type Updated"))
        .catchError((error) => print("Failed to add type: $error"));
  }
}

void contact() async {
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  prefs = await _prefs;
  SOSUser user = SOSUser();
  CollectionReference emergency =
      FirebaseFirestore.instance.collection('SOSEmergencies');

  user.contactMedicalPermission = (prefs.containsKey("contactMedicalPermission")
      ? prefs.getBool("contactMedicalPermission")
      : false)!;
  print(user.contactMedicalPermission);
  if (user.contactMedicalPermission == true) {
    await emergency
        .doc(mobile)
        .update({
          'type': 4,
        })
        .then((value) => print("Call type Updated"))
        .catchError((error) => print("Failed to add type: $error"));
  } else {
    await emergency
        .doc(mobile)
        .update({
          'type': 5,
        })
        .then((value) => print("Call type Updated"))
        .catchError((error) => print("Failed to add type: $error"));
  }
}

void standby() async {
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();

  await FirebaseFirestore.instance
      .collection('SOSEmergencies')
      .doc(mobile)
      .update({
        'type': 5,
      })
      .then((value) => print("Call type Updated"))
      .catchError((error) => print("Failed to add type: $error"));
}
