import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psap_dashboard/widget/navigation_drawer_widget.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
class SettingsHomePage extends StatefulWidget {
  final name;
  const SettingsHomePage({Key? key, required this.name}) : super(key: key);

  @override
  State<SettingsHomePage> createState() => _SettingsHomePageState();
}

class _SettingsHomePageState extends State<SettingsHomePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('PSAPUser');

  TextEditingController newPwd = TextEditingController();
  TextEditingController newPWD = TextEditingController();
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
        title: const Text('Reset Password'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              'Username: $name',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20), // Spacing visuals

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextField(
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'New Password',
              ),
              controller: newPwd,
            ),
          ),

          const SizedBox(height: 40), // Spacing visuals

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextField(
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
              controller: newPWD,
            ),
          ),

          const SizedBox(height: 40),

          SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.02,
              child: ElevatedButton(
                onPressed: () {
                  if (newPwd.text == newPWD.text) {
                    var bytes = utf8.encode(newPwd.text);
                    Digest sha256Result = sha256.convert(bytes);
                    String pwdHashed =  sha256Result.toString();
                    users.get().then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if (doc["username"] == name) {
                          Future<void> updateUser() {
                            return users
                                .doc(doc.id)
                                .update({'password': pwdHashed});
                          }

                          updateUser();
                        }
                      }
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                title: const Text('Password Updated'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                      newPwd.clear();
                                      newPWD.clear();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ]));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                    'Password not match, please reenter a new password'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                      newPwd.clear();
                                      newPWD.clear();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ]));
                  }
                },
                child: const Text('Submit'),
              ))
        ],
      ));
}
