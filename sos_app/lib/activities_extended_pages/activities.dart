import 'package:flutter/material.dart';
import 'package:sos_app/activities_extended_pages/activity_detail.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

class ActivitiesPage extends StatelessWidget {

  const ActivitiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){

      return Container(

        child: Column(
          children: <Widget>[
            InkWell(
        child: Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.add_alert_outlined),
              Container(
                child: Text('  Log 2  10 October 2021',style: TextStyle(
                  color: Colors.white,
                ),),
              )

          ]

          ),
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue,
          ),
        ),
              onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ActivityDetailPage()),
                  );
              },
            ),
    InkWell(
    child:
        Container(
            child: Row(
                children: <Widget>[
                  Icon(Icons.add_alert_outlined),
                  Container(
                    child: Text('  Log 1  15 March 2021',style: TextStyle(
                      color: Colors.white,
                    ),),
                  )

                ]

            ),
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue,
          ),
        ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ActivityDetailPage()),
        );
      },
    ),

          ],
        ),
    );

  }

}