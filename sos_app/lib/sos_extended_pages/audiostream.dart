import 'package:flutter/material.dart';


class AudioStream extends StatelessWidget {
  final signaling;
  final localRenderer;
  AudioStream({Key? key, required this.signaling, required this.localRenderer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call_end),
            onPressed: () {
              signaling.hangUp(localRenderer);
              Navigator.of(context).pop(null);
            },
          )
        ],
      ),
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Expanded(child: RTCVideoView(localRenderer)),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
