import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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
                    child: SfCartesianChart(
                      // Initialize category axis
                        primaryXAxis: CategoryAxis(),
                        series: <LineSeries<Emergency, String>>[
                          LineSeries<Emergency, String>(
                            // Bind data source
                              dataSource:  <Emergency>[
                                Emergency('01:00', 2),
                                Emergency('02:00', 8),
                                Emergency('03:00', 4),
                                Emergency('04:00', 3),
                                Emergency('05:00', 40),
                                Emergency('06:00', 5),
                                Emergency('07:00', 15),
                                Emergency('08:00', 8),
                                Emergency('09:00', 6),
                                Emergency('10:00', 9),
                                Emergency('11:00', 2),
                                Emergency('12:00', 7),
                                Emergency('13:00', 55),
                                Emergency('14:00', 2),
                                Emergency('15:00', 12),
                                Emergency('16:00', 0),
                                Emergency('17:00', 4),
                                Emergency('18:00', 0),
                                Emergency('19:00', 22),
                                Emergency('20:00', 0),
                                Emergency('21:00', 0),
                                Emergency('22:00', 0),
                                Emergency('23:00', 0),
                                Emergency('24:00', 0),
                              ],
                              xValueMapper: (Emergency amount, _) => amount.hour,
                              yValueMapper: (Emergency amount, _) => amount.amount
                          )
                        ]
                    )
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
class Emergency {
  Emergency(this.hour, this.amount);
  final String hour;
  final double amount;
}
