import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:psap_dashboard/pages/maps_home_page.dart';

class LoginPage extends StatefulWidget {
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
  Widget build(BuildContext context) => Scaffold(
          body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: Text(
                'Saskatchewan NG 911',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 80), // Spacing visuals

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
                  icon: Icon(Icons.person),
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
                    pwd = value;
                    FirebaseFirestore.instance
                        .collection('PSAPUser')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        if (doc["username"] == username.text &&
                            doc["password"] != value) {
                          validNAME = true;
                          validPWD = false;
                        }
                        if (doc["username"] == username.text &&
                            doc["password"] == value) {
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
                  icon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                controller: password,
              ),
            ),
            const SizedBox(height: 60),
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
                  child: const Text('LOGIN'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                  ),
                ))
          ],
        ),
      ));
}
