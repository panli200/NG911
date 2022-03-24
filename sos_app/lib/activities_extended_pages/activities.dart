import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/routes/router.gr.dart';

class ActivitiesPage extends StatefulWidget {
  ActivitiesPage({Key? key}) : super(key: key);

  @override
  ActivitiesPageState createState() => ActivitiesPageState();
}

class ActivitiesPageState extends State<ActivitiesPage> {
  final DateFormat formatter = DateFormat().add_yMd().add_jm();

  @override
  Widget build(BuildContext context) {
    String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    Query activities = FirebaseFirestore.instance
        .collection('SoSUsers')
        .doc(mobile)
        .collection('Emergencies')
        .orderBy('StartTime', descending: true);
    final Stream<QuerySnapshot> activitiesList = activities.snapshots();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Logs"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: activitiesList,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading');
                      }

                      final data = snapshot.requireData;
                      return ListView.builder(
                          itemCount: data.size,
                          itemBuilder: (context, index) {
                            var id = data.docs[index].id;
                            return InkWell(
                              child: Container(
                                padding: EdgeInsets.all(20.0),
                                margin: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        FlutterRemix.file_info_line,
                                        color: Colors.amber,
                                        size: 30,
                                      ),
                                      Container(
                                        child: Text(
                                          ' Date: ${formatter.format(DateTime.parse(data.docs[index]['StartTime']))}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                              onTap: () {
                                var router = context.router;
                                router.push(ActivityDetailRoute(
                                    Activity: id, Snapshot: data.docs[index]));
                              },
                            );
                          });
                    }))
          ],
        ),
      ),
    );
  }
}
