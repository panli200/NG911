import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sos_app/sos_extended_pages/sos_home_page.dart';


class InitializerWidgetPage extends StatefulWidget {
  @override
  _InitializerWidgetStatePage createState() => _InitializerWidgetStatePage();
}

class _InitializerWidgetStatePage extends State<InitializerWidgetPage> {

  late FirebaseAuth _auth;

  late User _user;

  bool isLoading = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _auth = FirebaseAuth.instance;
    _user = _auth.currentUser!;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
    } else {
      // ignore: unnecessary_null_comparison
      if (_user == null) {
        MaterialPageRoute(builder: (context) => SosHomePage());
        return Scaffold(

        );

      } else {
         MaterialPageRoute(builder: (context) => SosHomePage());
         return Scaffold(

         );
      }
    }
  }
}