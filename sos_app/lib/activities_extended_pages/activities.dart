import 'package:flutter/material.dart';
import 'package:sos_app/activities_extended_pages/activity_detail.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_remix/flutter_remix.dart';

class ActivitiesPage extends StatefulWidget {
  ActivitiesPage({Key? key}) : super(key: key);

  @override
  ActivitiesPageState createState() => ActivitiesPageState();
}



class ActivitiesPageState extends State<ActivitiesPage> {


  final DateFormat formatter = DateFormat().add_yMd().add_jm();

  @override
  Widget build(BuildContext context){
    String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    Query activities = FirebaseFirestore.instance.collection('SoSUsers').doc(mobile).collection('Emergencies').orderBy('StartTime', descending: true);
    final Stream<QuerySnapshot> activitiesList = activities.snapshots();
      return Container(

        child: Column(
          children: <Widget>[
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: activitiesList,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot,
                        ){

                      if(snapshot.hasError){
                        return Text('Something went wrong');
                      }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Text('Loading');
                      }

                      final data = snapshot.requireData;
                      return ListView.builder(
                          itemCount: data.size,
                          itemBuilder: (context, index){
                            var id = data.docs[index].id;
                            return  InkWell(
                              child: Container(
                                child: Row(
                                    children: <Widget>[
                                      Icon(FlutterRemix.file_info_line),
                                      Container(
                                        child: Text(' Date: ${formatter.format(DateTime.parse(data.docs[index]['StartTime']))}',style: TextStyle(
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
                              onTap: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ActivityDetailPage(Activity: id,Snapshot: data.docs[index])),
                                );
                              },
                            );

                          }
                      );
                    }
                )
            )


          ],

        ),
    );

  }

}
