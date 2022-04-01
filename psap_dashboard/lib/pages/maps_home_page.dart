import 'package:flutter/material.dart';
import 'package:psap_dashboard/pages/maps.dart';
import 'package:psap_dashboard/widget/navigation_drawer_widget.dart';
import 'call_control_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:firebase_database/firebase_database.dart' as fbdb;
import 'package:pointycastle/api.dart' as crypto;
import 'encryption.dart';
import 'dart:async';

class MapsHomePage extends StatefulWidget {
  final name;
  const MapsHomePage({Key? key, required this.name}) : super(key: key);

  @override
  State<MapsHomePage> createState() => _MapsHomePageState();
}

class _MapsHomePageState extends State<MapsHomePage> {
  Future<crypto.AsymmetricKeyPair>? futureKeyPair;
  crypto.AsymmetricKeyPair?
  keyPair; //to store the KeyPair once we get data from our future
  late var publicKey;
  late var privKey;
  late String publicKeyString;
  String? timeWaited = "0";
  String timeWaitedString = '0';
  String name = '';

  void getUSer() async {
    Future.delayed(Duration.zero, () {
      setState(() {
        name = widget.name;
      });
    });
  }

  void doEncryption() async {
    privKey = getPrivateKey();
    publicKeyString = getPublicKey();
    setState(() {});
  }

  @override
  void initState() {
    doEncryption();
    getUSer();
    super.initState();
  }

  @override
  void dispose() async {
    // clear users
    super.dispose();
  }

  final Stream<QuerySnapshot> waitingList =
  FirebaseFirestore.instance.collection('SOSEmergencies').snapshots();
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: NavigationDrawerWidget(name: name),
      appBar: AppBar(
        title: const Text('Emergencies'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.59,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 1)),
                child: GoogleMap(),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ), // SPACING

              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.38,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 1)),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),

                    const Text(
                      'Index',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),

                    const Divider(
                      height: 5,
                      thickness: 3,
                      color: Colors.black12,
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),

                    Row
                      (
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                      [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Waiting List',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.01,
                              ),

                              SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.68,
                                  width: MediaQuery.of(context).size.width * 0.18,
                                  // height: 200.0,
                                  child: StreamBuilder<
                                      QuerySnapshot> // This will read the Waiting list from Firebase (SOSEmergencies)
                                    (
                                      stream: waitingList,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                              void getTimeWaited(String? phone) async {
                                                WidgetsFlutterBinding
                                                    .ensureInitialized();
                                                fbdb.DatabaseReference ref = fbdb
                                                    .FirebaseDatabase.instance
                                                    .ref();
                                                ref
                                                    .child('sensors')
                                                    .child(phone!)
                                                    .child('Timer')
                                                    .onValue
                                                    .listen((event) async {
                                                  timeWaited =
                                                      event.snapshot.value!.toString();

                                                  if (timeWaited != null) {
                                                    timeWaitedString = timeWaited!;
                                                    Future.delayed(Duration.zero, () {
                                                      setState(() {});
                                                    });
                                                  }
                                                });
                                              }

                                              String phone = "";
                                              int? type = 5;
                                              var id = data.docs[index].id;
                                              phone =
                                                  data.docs[index]['Phone'].toString();
                                              type = data.docs[index]['type'];
                                              if (data.docs[index]['Waiting']) {
                                                getTimeWaited(data.docs[index].id);
                                                return Material(
                                                  color: Colors.white,
                                                  child: Container(
                                                    color: Colors.white,
                                                    margin: const EdgeInsets.all(10.0),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          ElevatedButton(
                                                              style: ButtonStyle(
                                                                backgroundColor:
                                                                MaterialStateProperty.all<
                                                                    Color>(Colors.red),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            CallControlPanel(
                                                                              CallerId: id,
                                                                              Snapshot:
                                                                              data.docs[
                                                                              index],
                                                                              type: type,
                                                                              name: name,
                                                                              publicKey:
                                                                              publicKeyString,
                                                                              privateKey:
                                                                              privKey,
                                                                            )));
                                                              },
                                                              child:
                                                              Column
                                                                (
                                                                children: [
                                                                  Row
                                                                    (
                                                                      children:
                                                                      [
                                                                        const Icon(FlutterRemix.hotspot_line),

                                                                        Text(' ${" " + phone}'),
                                                                      ]
                                                                  ),

                                                                  SizedBox(height: MediaQuery.of(context).size.height * 0.001),

                                                                  const Text("Time waited", textAlign: TextAlign.center),

                                                                  Text(' ${timeWaitedString + ""}'),
                                                                ],
                                                              )
                                                          ),
                                                        ]),
                                                  ),
                                                );
                                              } else {
                                                return const Material( /*child: Text('test'),*/);
                                              }
                                            });
                                      }))
                            ]),


                        Column // This will read the Online list from Firebase (SOSEmergencies)
                          (children: <Widget>[
                          const Text('Online List',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                              textAlign: TextAlign.center),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),

                          SizedBox(
                            // height: 200.0,
                              height: MediaQuery.of(context).size.height * 0.68,
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: waitingList,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                          //var id = data.docs[index].id;
                                          if (data.docs[index]['Online']) {
                                            return Material(
                                              color: Colors.white,
                                              child: Container(
                                                color: Colors.white,
                                                margin: const EdgeInsets.all(10.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                            MaterialStateProperty.all<
                                                                Color>(Colors.blue),
                                                          ),
                                                          onPressed: () {},
                                                          child:
                                                          Column
                                                            (
                                                            children: [
                                                              const Icon(FlutterRemix.hotspot_fill),

                                                              SizedBox(height: MediaQuery.of(context).size.height * 0.001),

                                                              Text('${data.docs[index]['Phone']}'),
                                                            ],
                                                          )

                                                      ),
                                                    ]),
                                              ),
                                            );
                                          } else {
                                            return const Material();
                                          }
                                        });
                                  }))
                        ]),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
            ],
          ),
        ],
      ));
}