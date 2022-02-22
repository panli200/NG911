import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sos_app/sos_extended_pages/call.dart';
class  RingingPage extends StatefulWidget {

  final privateKey;
  final publicKey;
  final aesKey;
  RingingPage(
      {Key? key,
        required this.privateKey,
        required this.publicKey,
        required this.aesKey})
      : super(key: key);

  @override
  RingingPageState createState() => RingingPageState();
}


class RingingPageState extends State<RingingPage> {
  late final publicKey;
  late final privateKey;
  late final aesSecretKey;
  StreamSubscription? streamSubscriptionStarted;
  bool started = false;
  @override
  void initState(){
    publicKey = widget.publicKey;
    privateKey = widget.privateKey;
    aesSecretKey = widget.aesKey;
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    final databaseReal = ref.child('sensors').child(mobile);
    streamSubscriptionStarted=
        databaseReal.child('Online').onValue.listen((event) async {
          bool? StartedB = event.snapshot?.value as bool;
          started = StartedB;
          if (started == true) {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CallPage(privateKey: privateKey,publicKey: publicKey, aesKey: aesSecretKey)),
    );
          }
        });
    super.initState();
  }

  @override
  void dispose(){
    streamSubscriptionStarted!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
      "911 Dispatcher",
      style: TextStyle(color: Colors.black),
    )),
      body: Container(
    decoration: const BoxDecoration(
    color: Colors.white,
    ),
    child: Column(
    children: <Widget>[
    Expanded(
    child: Text(
    "Hang on, contacting 911"
    ),
    )])));
  }


}