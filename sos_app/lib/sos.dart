import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'profile.dart';
import 'activities.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
class SOS extends StatefulWidget {
  @override
  SOS_State createState() => SOS_State();
}

class SOS_State extends State<SOS> {
  int _currentIndex = 1;

  final tabs = [
    Center(child: Text('activities')),
    Home(),
    Profile(),
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
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.blue)
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        )
     
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DelayedList(),
      ),
    );
  }
}

class DelayedList extends StatefulWidget {
  @override
  _DelayedListState createState() => _DelayedListState();
}

class _DelayedListState extends State<DelayedList> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });

    return isLoading ? ShimmerList() : DataList(timer);
  }
}

class DataList extends StatelessWidget {
  final Timer timer;

  DataList(this.timer);

  @override
  Widget build(BuildContext context) {
    timer.cancel();
    return Scaffold(
      body:
        Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle
              ),
            ),// How To Use App Placeholder  

            SizedBox(height: 20), // Spacing visuals

            Center(
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.center,
                color: Colors.grey,
              ), // Soundwave Placeholder
            ),
            

            SizedBox(height: 20), // Spacing visuals

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              
              children: <Widget>[
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.grey,
                ), // Front Camera Preview Placeholder

                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.grey,
                ), // Back Camera Preview Placeholder
              ],
            ), // Front/Back camera placheolders

            SizedBox(height: 20), // Spacing visuals

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                Center(
                    child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    color: Colors.grey,
                  ), 
                ), // Scenario One Button Placeholder (GENERIC MEDICAL SCENARIO)

                Center(
                    child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    color: Colors.grey,
                  ), 
                ), // Scenario Two Button Placeholder

                Center(
                    child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    color: Colors.grey,
                  ), 
                ), // Scenario Three 
              ],
            ) // SOS Scenario Button Placeholders
          ],
        ),
      ) 
    );
  }
}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;

          print(time);

          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey[300],
                child: ShimmerLayout(),
                period: Duration(milliseconds: time),
              ));
        },
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle
            ),
          ),// How To Use App Placeholder  

          SizedBox(height: 20), // Spacing visuals

          Center(
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.8,
              alignment: Alignment.center,
              color: Colors.grey,
            ), // Soundwave Placeholder
          ),
          

          SizedBox(height: 20), // Spacing visuals

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
            children: <Widget>[
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width * 0.4,
                color: Colors.grey,
              ), // Front Camera Preview Placeholder

              Container(
                height: 150,
                width: MediaQuery.of(context).size.width * 0.4,
                color: Colors.grey,
              ), // Back Camera Preview Placeholder
            ],
          ), // Front/Back camera placheolders

          SizedBox(height: 20), // Spacing visuals

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  color: Colors.grey,
                ), 
              ), // Scenario One Button Placeholder (GENERIC MEDICAL SCENARIO)

              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  color: Colors.grey,
                ), 
              ), // Scenario Two Button Placeholder

              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  color: Colors.grey,
                ), 
              ), // Scenario Three Button Placeholder

              Center(
                  child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  color: Colors.grey,
                ), 
              ) // Scenario Four Button Placeholder
            ],
          ) // SOS Scenario Button Placeholders
        ],
      ),
    );
  }
}

