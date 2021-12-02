import 'package:flutter/material.dart';

class MapsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Map'),
      centerTitle: true,
      backgroundColor: Colors.red,
    ),
    body: 
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[ 
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.6,
                  color: Colors.red,
                  // child: 
                  //   Image.asset(
                  //   "assets/images/sk.png",
                  //   fit: BoxFit.cover
                  // ),  // not working  for some reason
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.grey,
                ),
              ],
            ), 
          ],
        )
      )
  );
}