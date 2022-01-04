import 'package:firebase_auth/firebase_auth.dart';

class SOSUser {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  bool generalPermission = false;
  String contactNum = '';
  bool personalMedicalPermission = false;
  String personalHealthNum = '';
  String personalMedicalFile = '';
  String personalMedicalFilePath = '';
  bool contactMedicalPermission = false;
  String contactHealthNum = '';
  String contactMedicalFile = '';
  String contactMedicalFilePath = '';

  SOSUser() {
    this.generalPermission = generalPermission;
    this.contactNum = contactNum;
    this.personalMedicalPermission = personalMedicalPermission;
    this.personalHealthNum = personalHealthNum;
    this.personalMedicalFile = personalMedicalFile;
    this.personalMedicalFilePath = personalMedicalFilePath;
    this.contactMedicalPermission = contactMedicalPermission;
    this.contactHealthNum = contactHealthNum;
    this.contactMedicalFile = contactMedicalFile;
    this.contactMedicalFilePath = contactMedicalFilePath;
  }
}
