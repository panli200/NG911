import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psap_dashboard/pages/maps_home_page.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String name = '';
  String pwd = '';
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool validNAME = true;
  bool validPWD = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => 
    Scaffold
    (
      backgroundColor: Colors.grey[100],
        body: Form(
        key: formKey,
        child: 
          Container
          (
            alignment: Alignment.center,
            child: 
              Container
              (
                height: MediaQuery.of(context).size.height  * 0.4,
                width: MediaQuery.of(context).size.width * 0.5,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'New Generation 911',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 40), // Spacing visuals

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              name = value;
                              FirebaseFirestore.instance
                                  .collection('PSAPUser')
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                for (var doc in querySnapshot.docs) {
                                  if (doc["username"] != value) {
                                    validNAME = false;
                                  }
                                }
                              });
                            });
                          },
                          validator: (value) {
                            if (validNAME == true) {
                              return null;
                            } else {
                              username.clear();
                              password.clear();
                              return 'Please enter valid username';
                            }
                          },
                          decoration: const InputDecoration(
                            icon: Icon(FlutterRemix.shield_user_line, size: 40,),
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                          ),
                          controller: username,
                        ),
                      ),

                      const SizedBox(height: 20), // Spacing visuals

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              var bytes = utf8.encode(value);
                              Digest sha256Result = sha256.convert(bytes);
                              pwd = sha256Result.toString();
                              FirebaseFirestore.instance
                                  .collection('PSAPUser')
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                for (var doc in querySnapshot.docs) {
                                  if (doc["username"] == username.text &&
                                      doc["password"] != sha256Result.toString()) {
                                    validNAME = true;
                                    validPWD = false;
                                  }
                                  if (doc["username"] == username.text &&
                                      doc["password"] == sha256Result.toString()) {
                                    validNAME = true;
                                    validPWD = true;
                                  }
                                }
                              });
                            });
                          },
                          validator: (value) {
                            if (validPWD == true) {
                              return null;
                            } else {
                              password.clear();
                              return 'Please enter valid password';
                            }
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                            icon: Icon(FlutterRemix.key_line, size: 40,),
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                          controller: password,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.03,
                          child: ElevatedButton(
                            onPressed: () async {
                              final isValid = formKey.currentState?.validate();
                              if (isValid!) {
                                formKey.currentState!.save();
                              }
                              FirebaseFirestore.instance
                                  .collection('PSAPUser')
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                for (var doc in querySnapshot.docs) {
                                  if (doc["username"] == name && doc["password"] == pwd) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => MapsHomePage(name: name)));
                                    username.clear();
                                    password.clear();
                                  }
                                }
                              });
                            },
                            child: const Text('LOG IN'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // background
                            ),
                          ))
                    ],
                ),
              )
          )

        
        
      ));
}
