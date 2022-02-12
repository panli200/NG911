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
  if(details['contact health card'] != null) {
    return details['contact health card'];
  }
  return '';
}
Future<String> getPersonalHealthCard (String phone)async{
  CollectionReference EmergencyData = FirebaseFirestore.instance.collection('SoSUsers').doc(phone).collection('Profile Information');
  var details =  await EmergencyData.doc('Medical Info').get();
  if (details['personal health card'] != null){
    return details['personal health card'];
  }
  return '';
}

Future<String> getUrlPMR (String phone)async{
  CollectionReference EmergencyData = FirebaseFirestore.instance.collection('SoSUsers').doc(phone).collection('Profile Information');
  var details =  await EmergencyData.doc('Medical Info').get();
  if(details['personal medical file download'] !=null) {
    return details['personal medical file download'];
  }
  return '';
}

Future<String> getUrlECMR (String phone)async{
  CollectionReference EmergencyData = FirebaseFirestore.instance.collection('SoSUsers').doc(phone).collection('Profile Information');
  var details =  await EmergencyData.doc('Contact Medical Info ').get();
  if(details['contact medical file download'] !=null) {
    return details['contact medical file download'];
  }
  return '';
}