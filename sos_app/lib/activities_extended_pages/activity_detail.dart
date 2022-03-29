import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_remix/flutter_remix.dart';

class ActivityDetailPage extends StatefulWidget {
  final Snapshot;
  final Activity;
  const ActivityDetailPage(
      {Key? key, required this.Activity, required this.Snapshot})
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Logs"),
        centerTitle: true,
      ),
      body: 
      Container
      (
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        margin: EdgeInsets.symmetric(vertical: 5),
        child:
          Container
          (
            padding: EdgeInsets.all(10.0),
            decoration: 
              BoxDecoration
              (
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 1)
              ),

              child: 
                Column
                (
                  children: 
                  [
                    Icon
                    (
                      FlutterRemix.file_info_line,
                      color: Colors.amber,
                      size: 30,
                    ),

                    SizedBox(height: 10), // Spacing visuals

                    const Divider(height: 5, thickness: 3, color: Colors.black12),

                    SizedBox(height: 10), // Spacing visuals
                    
                    SizedBox
                    (
                      child: 
                        Row
                        (
                          children: 
                          [
                    
                            Icon(FlutterRemix.time_line, color: Colors.teal, size: 30, ),

                            Text
                            (
                              ' Start time: ' + formatter.format(DateTime.parse(activitySnapshot['StartTime'])),
                              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17,),
                            )
                          ],
                        )
                    ),

                    SizedBox(height: 5), // Spacing visuals

                    SizedBox
                    (
                      child: 
                        Row
                        (
                          children: 
                          [
                            Icon(FlutterRemix.time_line, color: Colors.red, size: 30, ),

                            Text
                            (
                              ' End time: ' + formatter.format(activitySnapshot['EndTime'].toDate()),
                              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17,),
                            ),
                          ],
                        )
                    ),

                    SizedBox(height: 5), // Spacing visuals

                    SizedBox
                    (
                      child: 
                        Row
                        (
                          children: 
                          [
                            Icon(FlutterRemix.map_pin_line, color: Colors.red, size: 30, ),

                            Text
                            (
                              'Last Location Sent',
                              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17,),
                            ),
                          ],
                        )
                    ),

                    SizedBox(height: 5), // Spacing visuals

                    Center
                    (
                      child: 
                        Row
                        (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: 
                          [
                            Column
                            (
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: 
                              [
                                Text('Latitude', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17,)),
                                Text
                                (
                                  activitySnapshot['EndPointLatitude'],
                                  style: const TextStyle(fontSize: 17,),
                                ),
                              ],
                            ),

                            SizedBox(width: 50), // Spacing visuals

                            Column
                            (
                              children: 
                              [
                                Text('Longitude', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17,)),
                                Text
                                (
                                  activitySnapshot['EndPointLongitude'],
                                  style: const TextStyle(fontSize: 17,),
                                ),
                              ],
                            )
                            
                          ],
                        )
                    ),

                    // SizedBox
                    // (
                    //   child: 
                    //     Row
                    //     (
                    //       children: 
                    //       [
                    //         Text
                    //         (
                    //           'Latitude: ' + activitySnapshot['EndPointLatitude']
                    //         )
                    //       ],
                    //     )
                    // ),

                    // SizedBox(height: 5), // Spacing visuals

                    // SizedBox
                    // (
                    //   child: 
                    //     Row
                    //     (
                    //       children: 
                    //       [
                    //         Text('Longitude: ' + activitySnapshot['EndPointLongitude'])
                    //       ],
                    //     )
                    // )
                  ]
                ),
          )
      )
    );
  }
//
}
