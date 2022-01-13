import 'package:flutter/material.dart';
import 'package:sos_app/activities_extended_pages/activity_detail.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ActivitiesPage extends StatelessWidget {

  const ActivitiesPage({Key? key}) : super(key: key);

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
  final DateFormat formatter = DateFormat().add_yMd().add_jm();

  @override
  Widget build(BuildContext context){
    String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    CollectionReference activities = FirebaseFirestore.instance.collection('SoSUsers').doc(mobile).collection('Emergencies');
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
                                      Icon(Icons.add_alert_outlined),
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

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;

          print(time);

          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey,
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
      child: Column(
        children: <Widget>[
          Container(

        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey,
        ),
        ),// How To Use App Placeholder

        Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey,
        ),
        )]));
  }
}