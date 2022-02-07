import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CaseBasic extends StatelessWidget {
  final int type;
  final phone;
  final String emergencyContactNumberString;
  final String emergencyHealthCardNumberString;
  final String personalHealthCardString;
  CaseBasic({Key? key, required this.type, required this.phone, required this.emergencyContactNumberString, required this.emergencyHealthCardNumberString, required this.personalHealthCardString}): super(key: key);





  @override
  Widget build(BuildContext context) {
    void someFunction() {}
    switch(type){
      case 1: // Personal call, only first permission is granted
        return Column(
            children: [
          Text("Emergency contact number: " + emergencyContactNumberString),
        ]);

      case 2: // Personal call, two permissions are granted

        return Column(children: [
          Text("Emergency contact number: " + emergencyContactNumberString),
          Text("Personal health card: " + personalHealthCardString),
          ElevatedButton(
              onPressed: someFunction,
              child: const Text("Download Personal Medical Report")),
        ]);

      case 3: // Personal call, only Medial permission is granted
        return Column(children: [
          Text("Personal health card: " + personalHealthCardString),
          ElevatedButton(
              onPressed: someFunction,
              child: const Text("Download Personal Medical Report")),
        ]);

      case 4: // Emergency contact call, with Permission granted
        return Column(children: [
          Text("Emergency contact health card number: " + emergencyHealthCardNumberString),
          ElevatedButton(
              onPressed: someFunction,
              child: const Text("Download Emergency contact Medical Report")),
        ]);

      default: // Type 0 expected
        return Column(children: const [

        ]);

    }


  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

