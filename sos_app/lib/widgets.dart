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
        // height: 40,
        // width: 40,
        // margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              
              // decoration: BoxDecoration(
              //   color: Colors.grey,
              //   shape: BoxShape.circle
              // ),
        child:
          Image.asset("assets/images/HowToUsePlaceholder.png",
            height: 40,
            width: 40,
          ),
      )
    );
  }
}