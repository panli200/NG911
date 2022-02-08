import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
class CaseBasic extends StatelessWidget {
   int type;
  final phone;
  final String emergencyContactNumberString;
  final String emergencyHealthCardNumberString;
  final String personalHealthCardString;
  final String urlPMR; // url of personal medical report
  final String urlECMR; // url of emergency contact medical report
  CaseBasic({Key? key, required this.type, required this.phone, required this.emergencyContactNumberString, required this.emergencyHealthCardNumberString, required this.personalHealthCardString, required this.urlPMR, required this.urlECMR}): super(key: key);






  @override
  Widget build(BuildContext context) {
    if(type == 1 && emergencyContactNumberString == ""){
      type = 5;
    }else if(type == 2 && ((emergencyContactNumberString == "") || (personalHealthCardString == ""))){
      type = 5;
    }else if(type == 3 && personalHealthCardString == ""){
      type = 5;
    }else if(type == 4 && emergencyHealthCardNumberString == ""){
      type = 5;
    }
    void downloadTheURL() async {
      if (type != 4) {
        if (await canLaunch(urlPMR))
          await launch(urlPMR);
        else
          // can't launch url, there is some error
          throw "Could not launch $urlPMR";
      }else{
        if (await canLaunch(urlECMR))
          await launch(urlECMR);
        else
          // can't launch url, there is some error
          throw "Could not launch $urlECMR";
      }
    }
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
              onPressed:downloadTheURL,
              child: const Text("Download Personal Medical Report")),
        ]);

      case 3: // Personal call, only Medial permission is granted
        return Column(children: [
          Text("Personal health card: " + personalHealthCardString),
          ElevatedButton(
              onPressed: downloadTheURL,
              child: const Text("Download Personal Medical Report")),
        ]);

      case 4: // Emergency contact call, with Permission granted
        return Column(children: [
          Text("Emergency contact health card number: " + emergencyHealthCardNumberString),
          ElevatedButton(
              onPressed: downloadTheURL,
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

