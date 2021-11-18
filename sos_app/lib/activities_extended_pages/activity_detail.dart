import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ActivityDetailPage extends StatelessWidget {

  final Snapshot;

  const ActivityDetailPage({Key? key, required this.Snapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

        child: Column(
          children: [Center(child: Text('Date: ${Snapshot['Date']}\n Start time: ${Snapshot['StartTime']}\n End Time: ${Snapshot['EndTime']}\n Status: ${Snapshot['Status']}'))],

        ));
  }
}

