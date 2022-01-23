import 'dart:async';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psap_dashboard/widget/navigation_drawer_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class OverviewHomePage extends StatefulWidget {
  @override
  State<OverviewHomePage> createState() => _OverviewHomePageState();
}

class _OverviewHomePageState extends State<OverviewHomePage> {
 Timer? timer;
  var currentDay = DateTime.now();
  NumberFormat formatter = new NumberFormat("0000");
  final Stream<QuerySnapshot> history =
      FirebaseFirestore.instance.collection('History').snapshots();

  List<int> num = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];


  @override
  void initState() {
    // Timer.periodic(Duration(seconds: 1), (t) {  });

    //getNum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
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

                    child:StreamBuilder<QuerySnapshot>(
                        stream: history,
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
                          for (var doc in data.docs) {
                            if (DateTime.parse(doc.id).year == currentDay.year &&
                                DateTime.parse(doc.id).month == currentDay.month &&
                                DateTime.parse(doc.id).day == currentDay.day) {
                              for (int i = 0; i < 24; i++) {
                                if (DateTime.parse(doc.id).hour == i) {
                                    num[i] = num[i] + 1;
                                }
                              }
                            }
                          }
                          return   SfCartesianChart(
                           // Initialize category axis
                              primaryXAxis: CategoryAxis(),
                              series: <LineSeries<Emergency, String>>[
                                LineSeries<Emergency, String>(
                                    // Bind data source
                                    dataSource: <Emergency>[
                                      Emergency('01:00', num[0]),
                                      Emergency('02:00', num[1]),
                                      Emergency('03:00', num[2]),
                                      Emergency('04:00', num[3]),
                                      Emergency('05:00', num[4]),
                                      Emergency('06:00', num[5]),
                                      Emergency('07:00', num[6]),
                                      Emergency('08:00', num[7]),
                                      Emergency('09:00', num[8]),
                                      Emergency('10:00', num[9]),
                                      Emergency('11:00', num[10]),
                                      Emergency('12:00', num[11]),
                                      Emergency('13:00', num[12]),
                                      Emergency('14:00', num[13]),
                                      Emergency('15:00', num[14]),
                                      Emergency('16:00', num[15]),
                                      Emergency('17:00', num[16]),
                                      Emergency('18:00', num[17]),
                                      Emergency('19:00', num[18]),
                                      Emergency('20:00', num[19]),
                                      Emergency('21:00', num[20]),
                                      Emergency('22:00', num[21]),
                                      Emergency('23:00', num[22]),
                                      Emergency('24:00', num[23]),
                                    ],
                                    xValueMapper: (Emergency amount, _) =>
                                        amount.hour,
                                    yValueMapper: (Emergency amount, _) =>
                                        amount.amount)
                              ]);

                        }),

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
                            Expanded(
                                child: Text(
                              '#',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            Expanded(
                                child: Text(
                              'Time',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            Expanded(
                                child: Text(
                              'Mobile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            Expanded(
                                child: Text(
                              'Latitude',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            Expanded(
                                child: Text(
                              'Longitude',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ],
                        ),
                        Scrollbar(
                          isAlwaysShown: true,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: history,
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
                                            reverse: true,
                                            itemBuilder: (context, index) {
                                              if (DateTime.parse(data
                                                              .docs[index].id)
                                                          .year ==
                                                      currentDay.year &&
                                                  DateTime.parse(data
                                                              .docs[index].id)
                                                          .month ==
                                                      currentDay.month &&
                                                  DateTime.parse(data
                                                              .docs[index].id)
                                                          .day ==
                                                      currentDay.day) {

                                                return Material(
                                                  child: Container(
                                                    height: 30,
                                                    child:
                                                        Row(children: <Widget>[
                                                      Text(formatter.format(
                                                              index + 1) +
                                                          '   ' +
                                                          DateTime.parse(data
                                                                  .docs[index]
                                                                  .id)
                                                              .toString() +
                                                          '  ${data.docs[index]['Phone']} '
                                                              '  ${data.docs[index]['Location'].latitude}'
                                                              '   ${data.docs[index]['Location'].longitude}'),
                                                    ]),
                                                  ),
                                                );
                                              } else {
                                                return const Material();
                                              }
                                            });
                                      }),
                                ),
                              ],
                            ),
                          ),
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
  final int amount;
}
