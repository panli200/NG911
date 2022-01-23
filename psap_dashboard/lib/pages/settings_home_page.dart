import 'package:flutter/material.dart';
import 'package:psap_dashboard/widget/navigation_drawer_widget.dart';

class SettingsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text('Reset Password'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text('Username  admin'),
            ),

            SizedBox(height: 20), // Spacing visuals

            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New Password',
                  )),
            ),

            SizedBox(height: 20), // Spacing visuals

            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  )),
            ),

            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Submit'),
                ))
          ],
        ),
      ));
}
