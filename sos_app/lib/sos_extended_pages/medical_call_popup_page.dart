import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/data/application_data.dart';
import 'package:sos_app/routes/router.gr.dart';

class MedicalCallPopUpPage extends StatelessWidget {

  final int medicalCallPopUpID;

  const MedicalCallPopUpPage({
    Key? key,
    @PathParam() required this.medicalCallPopUpID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medicalCallPopUp = MedicalCallPopUpData.medicalCallPopUp;

    return Scaffold (
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                medicalCallPopUp.title,
                style: Theme.of(context).textTheme.headline4,
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                'Who is this call for?',
                textAlign: TextAlign.center,
              ),

              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: Text('Yourself')
                ), 
              ), 

              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: Text('Emergency Contact')
                ), 
              ), 
            ],
          ),
        ),
      ),
    );
  }
}