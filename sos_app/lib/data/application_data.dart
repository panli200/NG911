import 'package:flutter/material.dart';

class HowToUseData {
  static final howToUsePopUp = HowToUseData(Colors.white, 'How To Use', 1);

  final Color color;
  final String title;
  final int id;

  HowToUseData(this.color, this.title, this.id);
}

class MedicalCallPopUpData {
  static final medicalCallPopUp = MedicalCallPopUpData(Colors.white, 'Medical Emergency Call', 2);

  final Color color;
  final String title;
  final int id;

  MedicalCallPopUpData(this.color, this.title, this.id);
}