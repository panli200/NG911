import 'package:flutter/material.dart';
import 'package:psap_dashboard/pages/maps_street.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as FbDb;
import 'package:firebase_core/firebase_core.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:permission_handler/permission_handler.dart';
import 'maps_home_page.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'signaling.dart';


class CallControlPanel extends StatefulWidget {
  final CallerId;
  final Snapshot;
  const CallControlPanel({Key? key, required this.CallerId, required this.Snapshot}) : super(key: key);

  @override
  State<CallControlPanel> createState() => _CallControlPanelState();
}

class _CallControlPanelState extends State<CallControlPanel> {
//used for map_street file
late String Latitude;
late String Longitude;

  // End video streaming code

  final FbDb.FirebaseDatabase database = FbDb.FirebaseDatabase.instance;
  FbDb.DatabaseReference ref = FbDb.FirebaseDatabase.instance.ref();
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('testCalls').snapshots();
  var FriendID;
  var snapshot;
  var realTimeSnapshot;
  var path;
  var MobileChargeString;
  var LongitudeString;
  var LatitudeString;
  var xAccString;
  var yAccString;
  var zAccString;
  var endTime;
  final senttext = new TextEditingController();
  FbDb.DatabaseReference? _db;
  void _callPolice() async{
    const number = '01154703794'; //set the number here
  }
  void _callFireDepartment() async{
    const number = '01154703795'; //set the number here
  }
  void _callEMS() async{
    const number = '01154703796'; //set the number here
  }
  void _EndCall() async{

    var now = new DateTime.now();
    var date = now.toString();

    FirebaseFirestore.instance.collection('SOSEmergencies').doc(FriendID).update({'Online': false});

    FirebaseFirestore.instance.collection('SOSUsers').doc(FriendID).collection('Emergencies').doc('Emergency' + date).update(
      {
        'endTime: ': FieldValue.serverTimestamp(),
      }
    );
    dispose();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (
                context) =>const MapsHomePage()));
  }

  void activateListeners(){
    ref.child('sensors').child(FriendID).child('MobileCharge').onValue.listen((event) {
      String MobileCharge = event.snapshot.value.toString();
      setState((){
        MobileChargeString = 'Mobile Charge: ' + MobileCharge;
      });
    });

    ref.child('sensors').child(FriendID).child('Longitude').onValue.listen((event) {
      Longitude = event.snapshot.value.toString();
      setState((){
        LongitudeString = 'Longitude: ' + Longitude;
      });
    });

    ref.child('sensors').child(FriendID).child('Latitude').onValue.listen((event) {
      Latitude = event.snapshot.value.toString();
      setState((){
        LatitudeString = 'Latitude: ' + Latitude;
      });
    });

    ref.child('sensors').child(FriendID).child('x-Acc').onValue.listen((event) {
      String xAcc = event.snapshot.value.toString();
      setState((){
        xAccString = 'Acceleration x: ' + xAcc;
      });
    });

    ref.child('sensors').child(FriendID).child('y-Acc').onValue.listen((event) {
      String yAcc = event.snapshot.value.toString();
      setState((){
        yAccString = 'Acceleration y: ' + yAcc;
      });
    });

    ref.child('sensors').child(FriendID).child('z-Acc').onValue.listen((event) {
      String zAcc = event.snapshot.value.toString();
      setState((){
        zAccString = 'Acceleration z: ' + zAcc;
      });
    });
  }

  @override
  void initState() {
    // Video steraming stuff
    // TODO: implement initState
    super.initState();
     // Video streaming
    FriendID = widget.CallerId; //Getting user ID from the previous page..
    activateListeners();
    
    snapshot = widget.Snapshot;
    FirebaseFirestore.instance.collection('SOSEmergencies').doc(FriendID).update({'Waiting': false}); // Changing the caller's Waiting state to be False
    FirebaseFirestore.instance.collection('SOSEmergencies').doc(FriendID).update({'Online': true}); // Changing the caller's Online state to be True
  }

  @override
  void dispose() async{
    // clear users
    var collection = FirebaseFirestore.instance.collection('SOSEmergencies').doc(FriendID).collection("messages");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    FbDb.FirebaseDatabase.instance.ref('sensors').child(widget.CallerId).remove();
    FbDb.FirebaseDatabase.instance.ref('users').child(widget.CallerId).remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Query sorted = FirebaseFirestore.instance.collection('SOSEmergencies').doc(FriendID).collection('messages').orderBy("time",descending: true);
    final Stream<QuerySnapshot> messages = sorted.snapshots();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Incoming Call Control Panel"),
          backgroundColor: Colors.redAccent,

        ),
        body: Column(
            children: <Widget>[
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Row(
                      children: <Widget>[
                        Column( // First Column

                            children: <Widget>[
                              Row( // For Map
                                  children: <Widget>[
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.30,
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      child: StreetMap(latitude: Latitude,longitude: Longitude ),
                                    )
                                  ]
                              ),
                              Row( // For Call History
                                  children: <Widget>[
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.45,
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: Scrollbar(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Caller History',
                                                      style: TextStyle(fontSize: 25),
                                                      textAlign: TextAlign.center,

                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '13 December 2012',

                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '8 January 2009',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),),
                                      ),
                                    )
                                  ]
                              ),
                              Row( // For Closing the call
                                  children: <Widget>[
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.10,
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: ElevatedButton(
                                          child: Text("End Call"),
                                          onPressed: _EndCall, // this will the method for your rejected Button
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                                          )
                                      ),
                                    )]
                              )
                            ]
                        ),

                        Column(
                          children: [
                            //////
                            // This is the User Info
                            //////
                            SizedBox(height: MediaQuery.of(context).size.height * 0.15,
                                  width: MediaQuery.of(context).size.width * 0.3,

                                  child: Row(children: [Scrollbar(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            child: Row(
                                              children: const [
                                                Text(
                                                  'Caller Information',
                                                  style: TextStyle(fontSize: 25),
                                                  textAlign: TextAlign.center,

                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Phone: ${snapshot['Phone']}',

                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '$MobileChargeString',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '$LongitudeString',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '$LatitudeString',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '$xAccString',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '$yAccString',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '$zAccString',
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),),
                                  ),],)),


                            const Divider(
                              height: 5,
                              thickness: 3,
                            ),

                              //////
                              // This is the chat
                              //////
                            SizedBox(height: MediaQuery.of(context).size.height * 0.6,
                                  width: MediaQuery.of(context).size.width * 0.3,

                                  child: Row(children: [Expanded(
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: messages,
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
                                                reverse: true,
                                                itemCount: data.size,
                                                itemBuilder: (context, index){
                                                  Color c;
                                                  Alignment a;
                                                  if(data.docs[index]['SAdmin'] == false){
                                                    c = Colors.blueGrey;
                                                    a = Alignment.centerLeft;
                                                  }else{
                                                    c = Colors.lightGreen;
                                                    a = Alignment.centerRight;
                                                  }

                                                  return SizedBox(
                                                      child:Align(
                                                          alignment: a,
                                                          child: Container(
                                                            child: Text('  ${data.docs[index]['Message']}',style: const TextStyle(
                                                                color: Colors.white
                                                            ),),


                                                            constraints: const BoxConstraints(
                                                              maxHeight: double.infinity,
                                                            ),

                                                            padding: EdgeInsets.all(10.0),
                                                            margin: EdgeInsets.all(10.0),
                                                            decoration: BoxDecoration(
                                                              color: c,
                                                              borderRadius: BorderRadius.circular(35.0),
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                    offset: Offset(0, 3),
                                                                    blurRadius: 5,
                                                                    color: Colors.grey)
                                                              ],
                                                            ),
                                                          )
                                                      )
                                                  );


                                                  //return Text('Date: ${data.docs[index]['date']}\n Start time: ${data.docs[index]['Start time']}\n End Time: ${data.docs[index]['End time']}\n Status: ${data.docs[index]['Status']}');

                                                }
                                            );
                                          }
                                      )
                                  ),],)),

                            const Divider(
                              height: 5,
                              thickness: 3,
                            ),
                            //////
                            // This is the reply
                            //////
                              SizedBox(height: MediaQuery.of(context).size.height * 0.12,
                                  width: MediaQuery.of(context).size.width * 0.3,

                                  child: Row(children: [
                                    Container(
                                      height: 70,
                                      constraints: const BoxConstraints(
                                        maxHeight: double.infinity,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(35.0),
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                      margin: EdgeInsets.all(20.0),
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: senttext,
                                                style: TextStyle(color: Colors. white),
                                                decoration: const InputDecoration(
                                                    hintText: "Type Something...",
                                                    hintStyle: TextStyle( color:     Colors.white),
                                                    border: InputBorder.none),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.send ,  color: Colors.white),
                                              onPressed: () {
                                                String text = senttext.text;
                                                if(text!='') {
                                                  FirebaseFirestore.instance.collection('SOSEmergencies').doc(
                                                      FriendID).collection('messages').add(
                                                      {
                                                        'Message': text,
                                                        'SAdmin': true,
                                                        'time': FieldValue.serverTimestamp()
                                                      }

                                                  );
                                                  senttext.text = '';
                                                }
                                              },
                                            )
                                          ],
                                        ),

                                      )
                                  ),],)),

                          ]

                          ),





                      ]
                  )
              )
            ]
        )


    );


  }
}