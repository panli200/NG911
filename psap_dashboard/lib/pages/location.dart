// import 'dart:async';
// import 'package:firebase_database/firebase_database.dart' as FbDb;
// class Location{
//   Location(String callerId){
//     FbDb.DatabaseReference ref = FbDb.FirebaseDatabase.instance.ref();
//       var LongitudeFromRealTime;
//       var LatitudeFromRealTime;
//       var LongitudeEachSecond;
//       var LatitudeEachSecond;
//     ref
//         .child('sensors')
//         .child(callerId)
//         .child('Latitude')
//         .onValue
//         .listen((event) {
//       LatitudeFromRealTime = event.snapshot.value;
//     });
//
//         ref
//         .child('sensors')
//         .child(callerId)
//         .child('Longitude')
//         .onValue
//         .listen((event) {
//       LongitudeFromRealTime = event.snapshot.value;
//     });
//     Timer.periodic(Duration(seconds: 1), (t) {
//           LatitudeEachSecond = LatitudeFromRealTime;
//           LongitudeEachSecond = LongitudeFromRealTime;
// //          LocationControllerLatitude.sink.add(LatitudeEachSecond);
// //          LocationControllerLongitude.sink.add(LongitudeEachSecond);
//       }
//
//     );
//
//   }
//
// //  final LocationControllerLongitude = StreamController<double>.broadcast();
// //  final LocationControllerLatitude = StreamController<double>.broadcast();
// //  Stream<double> get streamLongitude => LocationControllerLongitude.stream;
// //  Stream<double> get streamLatitude => LocationControllerLatitude.stream;
// }