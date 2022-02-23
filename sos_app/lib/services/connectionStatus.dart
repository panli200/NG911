import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ConnectionStatus extends StatefulWidget{
  ConnectionStatus(
      {Key? key}): super(key: key);

  @override
  _ConnectionStatusState createState() => _ConnectionStatusState();
}


class _ConnectionStatusState extends State<ConnectionStatus>{
  bool connected = false;
  String connection = '';
  StreamSubscription? subscriptionConnection;

  @override
  void initState(){
     subscriptionConnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.none) {
        setState(() {
          connection = 'No internet connection';
        });
      }else{
        setState(() {
          connection = 'Connected';
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

    return Text(connection);
  }


}