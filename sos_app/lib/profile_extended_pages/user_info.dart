import 'package:firebase_auth/firebase_auth.dart';

class SOSUser {
  bool generalPermission = false;
  String contactNum = '';
  bool medicalPermission = false;
  String personalHealthNum = '';
  String personalMedicalFile = '';
  bool contactMedicalPermission = false;
  String contactHealthNum = '';
  String contactMedicalFile = '';
  String uid = FirebaseAuth.instance.currentUser!.uid;

  SOSUser(){
    this.generalPermission = generalPermission;
    this.contactNum = contactNum;
    this.medicalPermission = medicalPermission;
    this.personalHealthNum = personalHealthNum;
    this.personalMedicalFile = personalMedicalFile;
    this.contactMedicalPermission = contactMedicalPermission;
    this.contactHealthNum = contactHealthNum;
    this.contactMedicalFile = contactMedicalFile;
  }
}