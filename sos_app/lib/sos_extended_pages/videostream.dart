import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoStream extends StatelessWidget {
  final signaling;
  final localRenderer;
  VideoStream({Key? key, required this.signaling, required this.localRenderer})
      : super(key: key);

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
              signaling.hangUp(localRenderer);
              Navigator.of(context).pop(null);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(localRenderer)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
