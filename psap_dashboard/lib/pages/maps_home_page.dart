import 'package:flutter/material.dart';
import 'maps.dart';

class MapsHomePage extends StatefulWidget {

  @override
  State<MapsHomePage> createState() => _MapsHomePageState();
}

class _MapsHomePageState extends State<MapsHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
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
                  child: GoogleMap(),
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
