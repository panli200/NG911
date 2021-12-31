import 'package:flutter/material.dart';
import 'package:sos_app/sos_extended_pages/message.dart';

class GeneralEmergency extends StatefulWidget {
  @override
  _GeneralEmergency createState() => _GeneralEmergency();
}

class _GeneralEmergency extends State<GeneralEmergency> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Message()),
                );
              },
              child: Text('Message')
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
              onPressed: (){
              },
              child: Text('Video')
          ),
        ],
    );
  }

}
