import 'package:flutter/material.dart';

class HowToUseData {
  static final howToUsePopUp = HowToUseData(Colors.white, 'How To Use', 1);

  final Color color;
  final String title;
  final int id;

  HowToUseData(this.color, this.title, this.id);
}

class EmergencyCallPopUpData {
  static final emergencyCallPopUp = EmergencyCallPopUpData(Colors.white, 'Emergency Call', 2);

  final Color color;
  final String title;
  final int id;

  EmergencyCallPopUpData(this.color, this.title, this.id);
}

class ConnectPsapData {
  static final connectPsapData = ConnectPsapData(Colors.white, 'Emergency Call', 3);

  final Color color;
  final String title;
  final int id;

  ConnectPsapData(this.color, this.title, this.id);
}

class EmergencySMS{
  String? messageContent;
  String? messageType;
  EmergencySMS({@required this.messageContent, @required this.messageType});
}