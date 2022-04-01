import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sos_app/sos_extended_pages/signaling.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoStream extends StatefulWidget {
  VideoStream({Key? key})
      : super(key: key);

  @override
  _VideoStreamState createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  Color agreeToVideoColor = Colors.blue;
  @override
  void initState() {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam_off),
            onPressed: () {
              signaling.hangUp(_localRenderer);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(agreeToVideoColor),
                ),
                onPressed: () {
                  signaling.openUserMedia(_localRenderer, _remoteRenderer);
                  agreeToVideoColor = Colors.red;
                  setState(() {});
                },
                child: Text("I agree to open my camera"),
              ),
              // SizedBox(
              //   width: 8,
              // ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: () async {
                roomId = await signaling.createRoom(_remoteRenderer);
                textEditingController.text = roomId!;
                setState(() {});
              },
              child: Text("Start Video call"),
            ),

            SizedBox(
              width: 8,
            ),

          ]),
          SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(_localRenderer, mirror: false)),
                ],
              ),
            ),
          ),

          SizedBox(height: 8)
        ],
      ),
    );
  }
}
