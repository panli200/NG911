import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
      "911 Dispatcher",
      style: TextStyle(color: Colors.black),
    )));
  }


}