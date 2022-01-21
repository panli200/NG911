import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/routes/router.gr.dart';
import 'package:sos_app/data/application_data.dart';
import 'package:sos_app/widgets.dart';

class SosHomePage extends StatefulWidget {
  SosHomePage({Key? key}) : super(key: key);

  @override
  SosHomePageState createState() => SosHomePageState();
}

class SosHomePageState extends State<SosHomePage> {
  final howToUsePopUp = HowToUseData.howToUsePopUp;
  final emergencyCallPopUp = EmergencyCallPopUpData.emergencyCallPopUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        // children: <Widget>[
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            child: HowToUseButton(
                tileColor: howToUsePopUp.color,
                pageTitle: howToUsePopUp.title,
                onTileTap: () => context.router.push(
                      HowToUseRoute(
                        howToUseID: howToUsePopUp.id,
                      ),
                    ) // onTileTap
                ),
          ), // How To Use App Placeholder

          SizedBox(height: 20), // Spacing visuals

          SizedBox(height: 20), // Spacing visuals

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                      child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () {
                      context.router.push(
                        EmergencyCallPopUpRoute(
                          emergencyCallPopUpID: emergencyCallPopUp.id,
                        ),
                      );
                    },
                    child: Text("Generic Emergency 911"),
                  ))),
              const Divider(
                height: 10,
                thickness: 5,
              ),
            ],
          ) // SOS Scenario Button Placeholders
        ],
      ),
    ));
  }
}
