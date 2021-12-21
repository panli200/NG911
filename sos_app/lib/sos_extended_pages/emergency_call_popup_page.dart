import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/data/application_data.dart';
import 'package:sos_app/routes/router.gr.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class EmergencyCallPopUpPage extends StatelessWidget {

  final int emergencyCallPopUpID;

  const EmergencyCallPopUpPage({
    Key? key,
    @PathParam() required this.emergencyCallPopUpID,
  }) : super(key: key);

  void _callNumber() async{
    const number = '01154703796'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    final emergencyCallPopUp = EmergencyCallPopUpData.emergencyCallPopUp;
    final connectPsapData = ConnectPsapData.connectPsapData;

    return Scaffold (
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emergencyCallPopUp.title,
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
                      child:ElevatedButton(
                          child: Text("Yourself"),
                          onPressed: () => context.router.push(
                            ConnectPsapRoute(
                              connectPsapPageID: connectPsapData.id,
                            ),
                          )
                      )

                ), 
              ), 

              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.center,
                  //color: Colors.grey,
                      child:ElevatedButton(
                          child: Text("Emergency Contact"),
                          onPressed: _callNumber // this will the method for your rejected Button
                      )
                ), 
              ), 
              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.center,
                  //color: Colors.grey,
                      child:ElevatedButton(
                          child: Text("Third Party (Bystander)"),
                          onPressed: _callNumber // this will the method for your rejected Button
                      )
                ), 
              ), 
            ],
          ),
        ),
      ),
    );
  }
}