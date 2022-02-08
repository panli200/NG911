import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getEmergencyContactNumber (String phone)async{
  CollectionReference EmergencyData =  FirebaseFirestore.instance.collection('SoSUsers').doc(phone).collection('Profile Information');
  var details =  EmergencyData.doc('General Info').get();

  String Number = '';
  await details.then((snapshot) {
    Number = snapshot['emergency number'].toString();
    return Number;
  });
  return Number;
}
Future<String> getEmergencyContactHealthCard (String phone)async{
  CollectionReference EmergencyData = FirebaseFirestore.instance.collection('SoSUsers').doc(phone).collection('Profile Information');
  var details =  await EmergencyData.doc('Contact Medical Info').get();
  return details['contact health card'];
}
Future<String> getPersonalHealthCard (String phone)async{
  CollectionReference EmergencyData = FirebaseFirestore.instance.collection('SoSUsers').doc(phone).collection('Profile Information');
  var details =  await EmergencyData.doc('Medical Info').get();
  return details['personal health card'];
}

Future<String> getUrlPMR (String phone)async{
  CollectionReference EmergencyData = FirebaseFirestore.instance.collection('SoSUsers').doc(phone).collection('Profile Information');
  var details =  await EmergencyData.doc('Medical Info').get();
  return details['personal medical file download'];
}

Future<String> getUrlECMR (String phone)async{
  CollectionReference EmergencyData = FirebaseFirestore.instance.collection('SoSUsers').doc(phone).collection('Profile Information');
  var details =  await EmergencyData.doc('Contact Medical Info ').get();
  return details['contact medical file download'];
}