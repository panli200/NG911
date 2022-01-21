import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OverviewHomePage extends StatefulWidget {
  @override
  State<OverviewHomePage> createState() => _OverviewHomePageState();
}

class _OverviewHomePageState extends State<OverviewHomePage> {
  final Stream<QuerySnapshot> emergencies = FirebaseFirestore.instance
      .collection('SOSEmergencies')
      .orderBy('StartTime', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Overview'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
                Widget>[
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Call History',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          children: const [
                            Expanded(child: Text('Mobile Number')),
                            Expanded(child: Text('Calling Time')),
                            Expanded(child: Text('Latitude')),
                            Expanded(child: Text('Longitude')),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: emergencies,
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
                                        itemCount: data.size ,
                                        itemBuilder: (context, index) {
                                          if (data.docs[index]['Ended']) {
                                            return Material(
                                              child: Container(
                                                height: 30,
                                                child: Row(children: <Widget>[
                                                  Text(' ${data.docs[index]['Phone']} ' +
                                                      ' ${data.docs[index]['StartTime']} ' +
                                                      ' ${data.docs[index]['StartLocation'].latitude} '
                                                          ' ${data.docs[index]['StartLocation'].longitude}'),
                                                ]),
                                              ),
                                            );
                                          } else {
                                            return const Material();
                                          }
                                          //return Text('Date: ${data.docs[index]['date']}\n Start time: ${data.docs[index]['Start time']}\n End Time: ${data.docs[index]['End time']}\n Status: ${data.docs[index]['Status']}');
                                        });
                                  }),
                            ),
                          ],
                        ),
                      ],
                    )),
              ]),
        ]),
      );
}
