import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as Cloud;
import 'package:firebase_database/firebase_database.dart';
import 'package:sos_app/sos_extended_pages/signaling.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sos_app/sos_extended_pages/videostream.dart';

class CallPage extends StatefulWidget {
  CallPage({Key? key}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final senttext = new TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  bool? Ended;

  //Video Stream
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;

  @override
  void initState() {
    final databaseReal = ref.child('sensors').child(mobile);
    StreamSubscription? streamSubscriptionEnded;
    streamSubscriptionEnded =
        databaseReal.child('Ended').onValue.listen((event) async {
      bool? EndedB = event.snapshot?.value as bool;
      Ended = EndedB;
      if (Ended == true) {
        Navigator.pop(context);
      }
    });

    //Video Stream
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    final Cloud.Query sorted = Cloud.FirebaseFirestore.instance
        .collection('SOSEmergencies')
        .doc(mobile)
        .collection('messages')
        .orderBy("time", descending: true);
    final Stream<Cloud.QuerySnapshot> messages = sorted.snapshots();

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "911 Dispatcher",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.call, color: Colors.black),
                onPressed: () async {
                  signaling.openUserAudio(_localRenderer, _remoteRenderer);
                  roomId = await signaling.createRoom(_remoteRenderer);
                  setState(() {});
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            actions: <Widget>[
                              new IconButton(
                                  alignment: Alignment.center,
                                  icon: new Icon(
                                    Icons.phone,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    signaling.hangUp(_localRenderer);
                                    Navigator.of(context).pop(null);
                                  }),
                            ],
                          ));
                }),
            IconButton(
                icon: Icon(Icons.video_call_rounded, color: Colors.black),
                onPressed: () async {
                  signaling.openUserMedia(_localRenderer, _remoteRenderer);
                  roomId = await signaling.createRoom(_remoteRenderer);
                  setState(() {});
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoStream(
                            signaling: signaling,
                            localRenderer: _localRenderer)),
                  );
                }),
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: StreamBuilder<Cloud.QuerySnapshot>(
                        stream: messages,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<Cloud.QuerySnapshot> snapshot,
                        ) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading');
                          }

                          final data = snapshot.requireData;
                          return ListView.builder(
                              reverse: true,
                              itemCount: data.size,
                              itemBuilder: (context, index) {
                                Color c;
                                Alignment a;
                                if (data.docs[index]['SAdmin'] == false) {
                                  c = Colors.blueGrey;
                                  a = Alignment.centerRight;
                                } else {
                                  c = Colors.lightGreen;
                                  a = Alignment.centerLeft;
                                }

                                return Align(
                                    alignment: a,
                                    child: Container(
                                      child: Text(
                                        '  ${data.docs[index]['Message']}',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      constraints: const BoxConstraints(
                                        maxHeight: double.infinity,
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                      margin: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: c,
                                        borderRadius:
                                            BorderRadius.circular(35.0),
                                        boxShadow: const [
                                          BoxShadow(
                                              offset: Offset(0, 2),
                                              blurRadius: 2,
                                              color: Colors.grey)
                                        ],
                                      ),
                                    ));

                                //return Text('Date: ${data.docs[index]['date']}\n Start time: ${data.docs[index]['Start time']}\n End Time: ${data.docs[index]['End time']}\n Status: ${data.docs[index]['Status']}');
                              });
                        })),
                Container(
                  height: 70,
                  constraints: const BoxConstraints(
                    maxHeight: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(35.0),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 2,
                          color: Colors.grey)
                    ],
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: senttext,
                          style: TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                              hintText: "Type Something...",
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          String text = senttext.text;
                          if (text != '') {
                            String mobile = FirebaseAuth
                                .instance.currentUser!.phoneNumber
                                .toString();
                            Cloud.FirebaseFirestore.instance
                                .collection('SOSEmergencies')
                                .doc(mobile)
                                .collection('messages')
                                .add({
                              'Message': text,
                              'SAdmin': false,
                              'time': Cloud.FieldValue.serverTimestamp()
                            });
                            senttext.text = '';
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
