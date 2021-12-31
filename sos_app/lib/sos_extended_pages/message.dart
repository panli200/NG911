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

  bool _isLogin = true;

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
          SizedBox(
            height: 8.0,
          ),
          _buildInfoList(),
          SizedBox(
            height: 8.0,
          ),
          _buildSendPeerMessage(),
        ],
      ),
    );
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(APP_ID);
    _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log("Peer msg: " + peerId + ", msg: " + (message.text));
    };
    _client?.onConnectionStateChanged = (int state, int reason) {
      _log('Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      _client.login(null, userId); //create client and also login
      if (state == 5) {
        _client?.logout();
        _log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
  }

  // Widget _buildLogin() {
  //   return new ElevatedButton(
  //     child: Text(
  //       'Close',
  //     ),
  //     style: ElevatedButton.styleFrom(
  //       primary: Colors.red, // background (button) color
  //       onPrimary: Colors.white, // foreground (text) color
  //     ),
  //     onPressed: () {
  //       _isLogin = false;
  //       Navigator.pop(context);
  //     },
  //   );
  // }

  Widget _buildSendPeerMessage() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      new Expanded(
          child: new TextField(
              controller: _peerMessageController,
              decoration: InputDecoration(hintText: 'Input peer message'))),
      new ElevatedButton(
        child: Text('Send'),
        onPressed: _toggleSendPeerMessage,
      )
    ]);
  }

  Widget _buildInfoList() {
    return Expanded(
        child: Container(
            child: ListView.builder(
              itemExtent: 24,
              itemBuilder: (context, i) {
              return ListTile(
                contentPadding: const EdgeInsets.all(0.0),
                title: Text(_infoStrings[i]),
              );
            },
      itemCount: _infoStrings.length,
    )));
  }

  // void _toggleLogin() async {
  //   if (_isLogin) {
  //     try {
  //       await _client?.logout();
  //       _log('Disconnect success.');
  //
  //       setState(() {
  //         _isLogin = false;
  //       });
  //     } catch (errorCode) {
  //       _log('Disconnect error: ' + errorCode.toString());
  //     }
  //   } else {
  //     String userId = FirebaseAuth.instance.currentUser!.uid;
  //
  //     try {
  //       await _client?.login(null, userId);
  //       _log('Connect success: ' + userId);
  //       setState(() {
  //         _isLogin = true;
  //       });
  //     } catch (errorCode) {
  //       _log('Connect error: ' + errorCode.toString());
  //     }
  //   // }
  // }

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
      _log('Send message fails! error: ' + errorCode.toString());
    }
  }

  void _log(String info) {
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
  }
}
