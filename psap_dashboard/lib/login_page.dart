import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psap_dashboard/pages/maps_home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            child: TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
          ),

          const SizedBox(height: 20), // Spacing visuals

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextField(
                onChanged: (value) {
                  //Do something with the user input.
                },
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                )),
          ),
          const SizedBox(height: 40),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.03,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const MapsHomePage()));
                },
                child: const Text('LOGIN'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                ),
              ))
        ],
      ));
}
