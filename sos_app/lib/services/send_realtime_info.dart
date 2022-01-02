import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sos_app/services/location.dart';

void sendRealTimeInfo() async {
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();

  DatabaseReference ref = FirebaseDatabase.instance.ref('users');

  final databaseMap = ref.child(mobile).child('map');

  Location location =  Location();
  await location.getCurrentLocation();

  Stream<DatabaseEvent> stream = ref.onValue;

  stream.listen((DatabaseEvent event) {
    databaseMap.update({
      'Latitude': location.latitude.toString(),
      'Longitude': location.longitude.toString(),
    });
  });
}

