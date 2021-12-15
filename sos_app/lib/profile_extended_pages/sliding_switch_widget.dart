import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_switch/sliding_switch.dart';

class SlidingSwitchWidget extends StatelessWidget {
  final bool choice;
  final SystemUiChangeCallback  onClicked;

  const SlidingSwitchWidget({
    Key? key,
    required this.choice,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>SlidingSwitch(
    value: choice,
    width: 100,
    onChanged: onClicked,
    height: 30,
    animationDuration: const Duration(milliseconds: 400),
    onTap: () {},
    onDoubleTap: () {},
    onSwipe: () {},
    textOff: "No",
    textOn: "Yes",
    colorOn: const Color(0xffdc6c73),
    colorOff: const Color(0xff6682c0),
    background: const Color(0xffe4e5eb),
    buttonColor: const Color(0xfff7f5f7),
    inactiveColor: const Color(0xff636f7b),

  );
}