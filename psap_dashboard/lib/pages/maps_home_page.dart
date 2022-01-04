import 'package:flutter/material.dart';
import 'package:psap_dashboard/pages/maps.dart';
import 'call_control_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapsHomePage extends StatefulWidget {
  const MapsHomePage({Key? key}) : super(key: key);

  @override
  State<MapsHomePage> createState() => _MapsHomePageState();
}

class _MapsHomePageState extends State<MapsHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final Stream<QuerySnapshot> Waiting =
      FirebaseFirestore.instance.collection('SOSEmergencies').snapshots();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.6,
                child: GoogleMap(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Text(
                      'Activity Call',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(
                      height: 5,
                      thickness: 3,
                    ),
                    const Text(
                      'Waiting List:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                        // This will read the Waiting list from Firebase (SOSEmergencies)

                        children: <Widget>[
                          SizedBox(
                              height: 200.0,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: Waiting,
                                  builder: (
                                    BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot,
                                  ) {
                                    if (snapshot.hasError) {
                                      return Text(
                                          'Something went wrong  ${snapshot.error}');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text('Loading');
                                    }

                                    final data = snapshot.requireData;
                                    return ListView.builder(
                                        itemCount: data.size,
                                        itemBuilder: (context, index) {
                                          var id = data.docs[index].id;
                                          if (data.docs[index]['Waiting']) {
                                            return Material(
                                              child: Container(
                                                child: Row(children: <Widget>[
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CallControlPanel(
                                                                      CallerId:
                                                                          id,
                                                                      Snapshot:
                                                                          data.docs[
                                                                              index])));
                                                    },
                                                    child: Text(
                                                        ' ${data.docs[index]['Phone']}'),
                                                  ),
                                                ]),
                                              ),
                                            );
                                          } else {
                                            return const Material();
                                          }
                                          //return Text('Date: ${data.docs[index]['date']}\n Start time: ${data.docs[index]['Start time']}\n End Time: ${data.docs[index]['End time']}\n Status: ${data.docs[index]['Status']}');
                                        });
                                  }))
                        ]),
                    const Divider(
                      height: 2,
                      thickness: 2,
                    ),
                    const Text(
                      'Online List:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                        // This will read the Online list from Firebase (SOSEmergencies)

                        children: <Widget>[
                          SizedBox(
                              height: 200.0,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: Waiting,
                                  builder: (
                                    BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot,
                                  ) {
                                    if (snapshot.hasError) {
                                      return Text(
                                          'Something went wrong  ${snapshot.error}');
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text('Loading');
                                    }

                                    final data = snapshot.requireData;
                                    return ListView.builder(
                                        itemCount: data.size,
                                        itemBuilder: (context, index) {
                                          var id = data.docs[index].id;
                                          if (data.docs[index]['Online']) {
                                            return Material(
                                              child: Container(
                                                child: Row(children: <Widget>[
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  Colors.blue),
                                                    ),
                                                    onPressed: () {},
                                                    child: Text(
                                                        '${data.docs[index]['Phone']}'),
                                                  ),
                                                ]),
                                              ),
                                            );
                                          } else {
                                            return const Material();
                                          }
                                          //return Text('Date: ${data.docs[index]['date']}\n Start time: ${data.docs[index]['Start time']}\n End Time: ${data.docs[index]['End time']}\n Status: ${data.docs[index]['Status']}');
                                        });
                                  }))
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ));
}
