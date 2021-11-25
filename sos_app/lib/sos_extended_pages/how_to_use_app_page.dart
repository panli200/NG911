import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/data/application_data.dart';
import 'package:sos_app/routes/router.gr.dart';

class HowToUsePage extends StatelessWidget {

  final int howToUseID;

  const HowToUsePage({
    Key? key,
    @PathParam() required this.howToUseID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final howToUsePopUp = HowToUseData.howToUsePopUp;

    return Scaffold (
      backgroundColor: Colors.white,
      body: Container(
        child: Padding( 
          padding: new EdgeInsets.only(top: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                howToUsePopUp.title,
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}