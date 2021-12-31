import 'dart:async';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'appId.dart';

class Message extends StatefulWidget {
  @override
  _Message createState() => _Message();
}

class _Message extends State<Message> {
  final _peerMessageController = TextEditingController();
  final _infoStrings = <String>[];
  late AgoraRtmClient _client;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _createClient();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          //_buildLogin(),
          _buildInfoList(),
          SizedBox(
            height: 16.0,
          ),
          _buildSendPeerMessage(),
        ],
      ),
    );
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(APP_ID);
    _client.login(null, userId); //create client and also login
    _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log(peerId + " : " + (message.text));
    };
  }

  Widget _buildSendPeerMessage() {
    return Row(children: <Widget>[
      new Expanded(
          child: new TextField(
              controller: _peerMessageController,
              decoration: InputDecoration(hintText: 'Input peer message'))),
      new ElevatedButton(
          child: Text('Send'),
          onPressed: () {
            _toggleSendPeerMessage();
            _peerMessageController.clear();
          })
    ]);
  }

  Widget _buildInfoList() {
    return Expanded(
        child: Container(
            child: ListView.builder(
      reverse: true,
      itemExtent: 20,
      itemBuilder: (context, i) {
        return ListTile(
          contentPadding: const EdgeInsets.all(0.0),
          title: Text(_infoStrings[i]),
        );
      },
      itemCount: _infoStrings.length,
    )));
  }

  void _toggleSendPeerMessage() async {
    String peerUid = '911'; //fixed peerUid 911, will fix it in firebase

    String text = _peerMessageController.text;
    if (text.isEmpty) {
      _log('Please input text to send.');
      return;
    }

    try {
      AgoraRtmMessage message = AgoraRtmMessage.fromText(text);
      _log(message.text);
      await _client?.sendMessageToPeer(peerUid, message, false);
      _log('Send message to 911 success.');
    } catch (errorCode) {
      _log('Send message fails!');
    }
  }

  void _log(String info) {
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
  }
}
