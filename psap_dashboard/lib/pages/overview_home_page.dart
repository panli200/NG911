import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psap_dashboard/widget/navigation_drawer_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_remix/flutter_remix.dart';

class OverviewHomePage extends StatefulWidget {
  final name;

  const OverviewHomePage({Key? key, required this.name}) : super(key: key);

  @override
  State<OverviewHomePage> createState() => _OverviewHomePageState();
}

class _OverviewHomePageState extends State<OverviewHomePage> {
  Timer? timer;
  var currentDay = DateTime.now();
  NumberFormat formatter = NumberFormat("0000");
  final Stream<QuerySnapshot> history =
      FirebaseFirestore.instance.collection('History').snapshots();

  List<int> num = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
  String name = '';

  void getUSer() {
    setState(() {
      name = widget.name;
    });
  }

  @override
  void initState() {
    getUSer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(
          name: name,
        ),
        appBar: AppBar(
          title: const Text('Overview'),
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
                  width: MediaQuery.of(context).size.width * 0.01,
                ), // SPACING

                Container // Call History Chart
                    (
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.48,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 1)),
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
                          return const Text('Loading');
                        }
                        final data = snapshot.requireData;
                        for (var doc in data.docs) {
                          if (DateTime.parse(doc.id).year == currentDay.year &&
                              DateTime.parse(doc.id).month ==
                                  currentDay.month &&
                              DateTime.parse(doc.id).day == currentDay.day) {
                            for (int i = 0; i < 24; i++) {
                              if (DateTime.parse(doc.id).hour == i) {
                                num[i] = num[i] + 1;
                              }
                            }
                          }
                        }
                        return SfCartesianChart(
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
                  width: MediaQuery.of(context).size.width * 0.01,
                ), // SPACING

                Container // Call History Data
                    (
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width * 0.48,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 1)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>
                          [
                            const Text(
                              'Emergency History',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const Divider(height: 5, thickness: 3, color: Colors.black12),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(children: const [
                                    Icon(FlutterRemix.history_line),
                                    Text(
                                      'Time',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ]),
                                ),

                                SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                                
                                Expanded(
                                  child: Column(children: const [
                                    Icon(FlutterRemix.smartphone_line),
                                    Text(
                                      'Mobile',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ]),
                                ),

                                SizedBox(width: MediaQuery.of(context).size.width * 0.03),

                                Expanded(
                                  child: Column(children: const [
                                    Icon(FlutterRemix.global_line),
                                    Text(
                                      'Latitude',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ]),
                                ),

                                SizedBox(width: MediaQuery.of(context).size.width * 0.03),

                                Expanded(
                                  child: Column(children: const [
                                    Icon(FlutterRemix.global_line),
                                    Text(
                                      'Longitude',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ]),
                                ),
                              ],
                            ),

                            Scrollbar(
                              isAlwaysShown: true,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: history,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Something went wrong  ${snapshot.error}');
                                            }

                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Text('Loading');
                                            }

                                            final data = snapshot.requireData;

                                            return ListView.builder(
                                                itemCount: data.size,
                                                itemBuilder: (context, index) {
                                                  if (DateTime.parse(data
                                                                  .docs[index]
                                                                  .id)
                                                              .year ==
                                                          currentDay.year &&
                                                      DateTime.parse(data
                                                                  .docs[index]
                                                                  .id)
                                                              .month ==
                                                          currentDay.month &&
                                                      DateTime.parse(data
                                                                  .docs[index]
                                                                  .id)
                                                              .day ==
                                                          currentDay.day) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                      child: SizedBox(
                                                        height: 30,
                                                        child: Flexible(
                                                          child: 
                                                          Row
                                                          (
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>
                                                            [
                                                              SizedBox(width: MediaQuery.of(context).size.width * 0.020),

                                                              Expanded(
                                                                child: Text(DateTime.parse(
                                                                        data
                                                                            .docs[
                                                                                index]
                                                                            .id)
                                                                    .toString()),
                                                              ),

                                                              SizedBox(width: MediaQuery.of(context).size.width * 0.03),

                                                              Expanded(
                                                                child: Text(
                                                                    data.docs[index]
                                                                        ['Phone']),
                                                              ),

                                                              SizedBox(width: MediaQuery.of(context).size.width * 0.035),

                                                              Expanded(
                                                                child: Text((data
                                                                        .docs[index]
                                                                            [
                                                                            'Location']
                                                                        .latitude)
                                                                    .toStringAsFixed(
                                                                        6)),
                                                              ),

                                                              SizedBox(width: MediaQuery.of(context).size.width * 0.035),

                                                              Expanded(
                                                                child: Text((data
                                                                        .docs[index]
                                                                            [
                                                                            'Location']
                                                                        .longitude)
                                                                    .toStringAsFixed(
                                                                        6)),
                                                              )
                                                            ]
                                                          ),
                                                        ),
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

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ), // SPACING
              ]),
        ]),
      );
}

class Emergency {
  Emergency(this.hour, this.amount);
  final String hour;
  final int amount;
}
