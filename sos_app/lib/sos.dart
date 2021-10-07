import 'package:flutter/material.dart';

class SOS extends StatefulWidget {
  @override
  SOS_State createState() => SOS_State();
}

class SOS_State extends State<SOS> {

int _currentIndex = 1;

   final tabs = [
     Center(child: Text('Activities')),
     Center(child: Text('SOS')),
     Center(child: Text('Profile')),
   ];

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

      ,)
    );
  }
}