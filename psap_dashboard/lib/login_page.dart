import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psap_dashboard/pages/maps_home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Center(
            child: Text(
              'Saskatchewan Public Safety Agency 911',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 80), // Spacing visuals

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextFormField(
              validator: (value) {
                if (value!.isNotEmpty && value.length <= 2) {
                  return 'The username not exist';
                }
                return null;
              },
              inputFormatters: <TextInputFormatter>[
                // FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
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
              validator: (value) {
                if (value!.isNotEmpty) {
                  return 'Please enter correct password';
                }
                return null;
              },
              inputFormatters: <TextInputFormatter>[
                // FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
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
                  FirebaseFirestore.instance
                      .collection('PSAPUser')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    for (var doc in querySnapshot.docs) {
                      if (doc["username"] == username.text &&
                          doc["password"] == password.text) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MapsHomePage()));
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
      ));
}
