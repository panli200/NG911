import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallPage extends StatefulWidget {
  CallPage({Key? key}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}


class _CallPageState extends State<CallPage> {

  final senttext = new TextEditingController();
  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    final Query sorted = FirebaseFirestore.instance.collection('SOSEmergencies').doc(mobile).collection('messages').orderBy("time",descending: true);
    final Stream<QuerySnapshot> messages = sorted.snapshots();
    return Scaffold(
        appBar: AppBar(
          title:  const Text("911", ),
          backgroundColor: Colors.black54,
        ),
        body: Container(

            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
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
                                  a = Alignment.centerRight;
                                }else{
                                  c = Colors.lightGreen;
                                  a = Alignment.centerLeft;
                                }

                                return Align(
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
                                );


                                //return Text('Date: ${data.docs[index]['date']}\n Start time: ${data.docs[index]['Start time']}\n End Time: ${data.docs[index]['End time']}\n Status: ${data.docs[index]['Status']}');

                              }
                          );
                        }
                    )
                ),

                Container(
                  height: 70,
                  constraints: const BoxConstraints(
                    maxHeight: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(35.0),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 5,
                          color: Colors.grey)
                    ],
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(20.0),
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
                            String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
                            FirebaseFirestore.instance.collection('SOSEmergencies').doc(
                                mobile).collection('messages').add(
                                {
                                  'Message': text,
                                  'SAdmin': false,
                                  'time': FieldValue.serverTimestamp()
                                }

                            );
                            senttext.text = '';
                          }
                        },
                      )
                    ],
                  ),
                ),



              ],
            )
        )

    );
  }
}