import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_app/profile_extended_pages/sos_user.dart';
import 'package:sos_app/profile_extended_pages/firebase_storage_API.dart';

Future uploadFile() async {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  prefs = await _prefs;
  SOSUser user = SOSUser();
  File? file1, file2;
  UploadTask? task1, task2;

  user.personalMedicalPermission =
      (prefs.containsKey("PersonalMedicalPermission")
          ? prefs.getBool("PersonalMedicalPermission")
          : false)!;
  user.personalMedicalFilePath = (prefs.containsKey("PersonalFilePath")
      ? prefs.getString("PersonalFilePath")
      : '')!;
  user.contactMedicalPermission =
      (prefs.containsKey("PersonalMedicalPermission")
          ? prefs.getBool("PersonalMedicalPermission")
          : false)!;
  user.contactMedicalFilePath = (prefs.containsKey("PersonalFilePath")
      ? prefs.getString("PersonalFilePath")
      : '')!;

  if (user.personalMedicalPermission == true) {
    file1 = File(user.personalMedicalFilePath);

    final destination = user.uid + '/PersonalPrescription';

    task1 = FirebaseApi.uploadFile(destination, file1);

    if (task1 == null) return;

    final snapshot = await task1.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }
  if (user.contactMedicalPermission == true) {
    file2 = File(user.contactMedicalFilePath);

    final destination = user.uid + '/ContactPrescription';

    task2 = FirebaseApi.uploadFile(destination, file2);

    if (task2 == null) return;

    final snapshot = await task2.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }
}
