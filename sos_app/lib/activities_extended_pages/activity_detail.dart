import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ActivityDetailPage extends StatefulWidget {
  final Snapshot;
  final Activity;
  const ActivityDetailPage({Key? key, required this.Activity ,required this.Snapshot})
      : super(key: key);

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}
//
class _ActivityDetailPageState extends State<ActivityDetailPage> {
  var mobile;
  var activitySnapshot;
  final DateFormat formatter = DateFormat().add_yMd().add_jm();
  @override
  void initState() {
    super.initState();
    mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    activitySnapshot = widget.Snapshot;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logs"),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(
                    child: Row(
                      children: [
                        Text('Start time: ' + formatter.format(DateTime.parse(activitySnapshot['StartTime'])))
                      ],

                    )

                ),
                SizedBox(
                    child: Row(
                      children: [
                        Text('End time: ' + formatter.format(activitySnapshot['EndTime'].toDate()))
                      ],

                    )

                ),
                SizedBox(
                    child: Row(
                      children: [
                        Text('Latitude: ' + activitySnapshot['EndPointLatitude'])
                      ],

                    )

                ),
                SizedBox(
                    child: Row(
                      children: [
                        Text('Longitude: ' + activitySnapshot['EndPointLongitude'])
                      ],

                    )

                )

              ]
          ),
        ),

      ),
    );
  }
//
}

