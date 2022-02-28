import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_remix/flutter_remix.dart';

class ConnectionStatus extends StatefulWidget{
  ConnectionStatus(
      {Key? key}): super(key: key);

  @override
  _ConnectionStatusState createState() => _ConnectionStatusState();
}


class _ConnectionStatusState extends State<ConnectionStatus>{
  bool connected = false;
  String connection = 'No internet connection!';
  Icon connectionIcon = Icon(FlutterRemix.signal_wifi_error_line);
  StreamSubscription? subscriptionConnection;

  @override
  void initState(){
     subscriptionConnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.none) {
        setState(() {
          connection = 'No internet connection!';
          connectionIcon = Icon(FlutterRemix.signal_wifi_error_line, color: Colors.red);
        });
      }else{
        setState(() {
          connection = 'Connected';
          connectionIcon = Icon(FlutterRemix.wifi_line,color: Colors.teal);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose(){
    subscriptionConnection!.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: 
        Row
        (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            connectionIcon,
            Text(connection)
          ],
        )
    );
  }
}