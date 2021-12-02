import 'package:flutter/material.dart';

  void showGeneralDialogBox(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('General Information Use',
              textAlign: TextAlign.center),
          content: const Text(
              'General information will be use for 911 emergency. '
                  'Your information only be used with your permission.'
                  'You have the responsibility to keep your information safe. '
                  'Your can select "No" for not giving your information to 911'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.close),
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
        title: const Text('Medical Information Use',
            textAlign: TextAlign.center),
        content: const Text(
            'Medical information will be use for 911 emergency. '
                'Your information only be used with your permission.'
                'You have the responsibility to keep your information safe. '
                'Your can select "No" for not giving your information to 911'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ],
      );
    },
  );
}