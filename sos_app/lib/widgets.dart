import 'package:flutter/material.dart';

class HowToUseButton extends StatelessWidget {
  final Color tileColor;
  final String pageTitle;
  final void Function() onTileTap;

  const HowToUseButton ({
    Key? key,
    required this.tileColor,
    required this.pageTitle,
    required this.onTileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTileTap,
      child: Container( 
        child:
          Image.asset("assets/images/HowToUsePlaceholder.png",
            height: 40,
            width: 40,
          ),
      )
    );
  }
}

class MedicalScenarioButton extends StatelessWidget {
  final Color tileColor;
  final String pageTitle;
  final void Function() onTileTap;

  const MedicalScenarioButton ({
    Key? key,
    required this.tileColor,
    required this.pageTitle,
    required this.onTileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTileTap,
      child: Container( 
          height: 50,
          width: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          color: Colors.grey,
          child: Text('Medical Emergency Call')
      )
    );
  }
}