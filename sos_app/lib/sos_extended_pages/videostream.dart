import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoStream extends StatefulWidget {
  final signaling;
  final localRenderer;
  final remoteRenderer;
  VideoStream(
      {Key? key,
      required this.signaling,
      required this.localRenderer,
      required this.remoteRenderer})
      : super(key: key);

  @override
  State<VideoStream> createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  Future<void> createRoom() async {
    await widget.signaling.createRoom(widget.remoteRenderer);
  }

  @override
  void initState() {
    createRoom();
    super.initState();
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
              widget.signaling.hangUp(widget.localRenderer);
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
                  Expanded(child: RTCVideoView(widget.localRenderer)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
