import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cryptography/cryptography.dart';

class Message extends StatefulWidget {
  var secretBox;
  var aesSecretKey;
  var alignment;
  var color;
  Message(
      {Key? key,
      required this.secretBox,
      required this.aesSecretKey,
      required this.alignment,
      required this.color})
      : super(key: key);
  @override
  State<Message> createState() => MessageState();
}

class MessageState extends State<Message> {
  final algorithm = AesCtr.with256bits(macAlgorithm: Hmac.sha256());
  var secretBox;
  var alignment;
  var color;
  var aesSecretKey;
  Future? decryptedMessage;

  Future<String> decryptText(SecretBox secretBox) async {
    return utf8.decode(
        await algorithm.decrypt(secretBox, secretKey: await aesSecretKey));
  }

  @override
  void initState() {
    secretBox = widget.secretBox;
    aesSecretKey = widget.aesSecretKey;
    color = widget.color;
    alignment = widget.alignment;
    decryptedMessage = decryptText(secretBox);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: decryptedMessage,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          String decryptedMessage = snapshot.data;
          return Align(
              alignment: alignment,
              child: Container(
                child: Text(
                  decryptedMessage,
                  style: const TextStyle(color: Colors.black),
                ),
                constraints: const BoxConstraints(
                  maxHeight: double.infinity,
                ),
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(35.0),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 2), blurRadius: 2, color: Colors.grey)
                  ],
                ),
              ));
        });
  }
}
