import 'package:flutter/material.dart';

void showGeneralDialogBox(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.amberAccent,
        title: const Text('General Information Use'),
        content: const Text(
            'General information will be used for 911 emergency call only with your permission. '
            'You have the responsibility to keep your information safe. '
            'Your can select "No" for not giving your information to 911 Saskatchewan Public Safety Agency.'),
        actions: <Widget>[
          new IconButton(
            alignment: Alignment.center,
            icon: new Icon(
              Icons.done,
              color: Colors.green,
            ),
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ],
      );
    },
  );
}

void showMedicalDialogBox(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.amberAccent,
        title: const Text('Medical Information Use'),
        content: const Text(
            'Medical information will be used for 911 emergency call only with your permission. '
            'You have the responsibility to keep your information safe. '
            'Your can select "No" for not giving your information to 911 Saskatchewan Public Safety Agency.'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.done, color: Colors.green),
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ],
      );
    },
  );
}
