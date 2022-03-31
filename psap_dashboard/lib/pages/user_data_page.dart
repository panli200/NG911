import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getEmergencyContactNumber(String phone) async {
  CollectionReference emergencyData = FirebaseFirestore.instance
      .collection('SoSUsers')
      .doc(phone)
      .collection('Profile Information');
  var details = emergencyData.doc('General Info').get();

  String number = '';
  await details.then((snapshot) {
    number = snapshot['emergency number'].toString();
    return number;
  });
  return number;
}

Future<String> getEmergencyContactHealthCard(String phone) async {
  CollectionReference emergencyData = FirebaseFirestore.instance
      .collection('SoSUsers')
      .doc(phone)
      .collection('Profile Information');
  var details = await emergencyData.doc('Contact Medical Info').get();
  if (details['contact health card'] != null) {
    return details['contact health card'];
  }
  return '';
}

Future<String> getPersonalHealthCard(String phone) async {
  CollectionReference emergencyData = FirebaseFirestore.instance
      .collection('SoSUsers')
      .doc(phone)
      .collection('Profile Information');
  var details = await emergencyData.doc('Medical Info').get();
  if (details['personal health card'] != null) {
    return details['personal health card'];
  }
  return '';
}

Future<String> getUrlPMR(String phone) async {
  try {
    CollectionReference? emergencyData = FirebaseFirestore.instance
        .collection('SoSUsers')
        .doc(phone)
        .collection('Profile Information');
    var details = await emergencyData.doc('Medical Info').get();

    if ((details.data() as dynamic)['personal medical file download'] != null) {
      return (details.data() as dynamic)['personal medical file download'];
    }
  }catch(e){

  }
  return '';
}

Future<String> getUrlECMR(String phone) async {
  try {
    CollectionReference emergencyData = FirebaseFirestore.instance
        .collection('SoSUsers')
        .doc(phone)
        .collection('Profile Information');
    var details = await emergencyData.doc('Contact Medical Info ').get();

    if (details['contact medical file download'] != null) {
      return details['contact medical file download'];
    }
  }catch(e){

  }
  return '';
}
