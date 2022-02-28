import 'package:flutter/material.dart';

showSOSDialogBox(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[100],
        title: const Text('Distress Signal Information', textAlign: TextAlign.center,),
        content: const Text(
            'Connect with a 911 dispatcher for yourself, for an emergency contacts behalf, or a third party. '),
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

showTrackingDialogBox(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[100],
        title: const Text('Tracking Location Use', textAlign: TextAlign.center,),
        content: const Text(
            'Start/stop the service for the application to track your location. '
            'The recorded location will be used by a 911 dispatcher to get information of where you were before you had sent a distress signal. '
            'The more information the dispatchers know, the better. This service is optional and not required.'),
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

showGeneralDialogBox(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[100],
        title: const Text('General Information Use', textAlign: TextAlign.center,),
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

 showMedicalDialogBox(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[100],
        title: const Text('Medical Information Use', textAlign: TextAlign.center,),
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
