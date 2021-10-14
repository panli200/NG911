import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'activities.dart';
import 'activity_detail.dart';
class SOS extends StatefulWidget {
  @override
  SOS_State createState() => SOS_State();
}

class SOS_State extends State<SOS> {

  int _currentIndex = 1;

  final tabs = [
    activities(),
    Center(child: Text('SOS')),
    Center(child: Text('Profile')),
  ];

  void _callNumber() async{
    const number = '01154703796'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SOS '),
          centerTitle: true,
        ),

        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(

          currentIndex: _currentIndex,

          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Activities',
                backgroundColor: Colors.blue
            ),

            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.blue
            ),

            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.blue
            )
          ],

          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }

          ,),
      floatingActionButton: FloatingActionButton(
      onPressed: _callNumber,
      tooltip: 'Increment',
      child: const Icon(Icons.call_rounded),
    ),
    );
  }
}
