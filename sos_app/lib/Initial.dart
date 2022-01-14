import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sos_app/SignUp.dart';
import 'package:sos_app/sos.dart';


class InitializerWidgetPage extends StatelessWidget {
  InitializerWidgetPage({Key? key}) : super(key: key);

  FirebaseAuth? _auth;

  User? _user;

  bool isLoading = true;
  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _user!= _auth?.currentUser;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {

    if (_user == null) {
      MaterialPageRoute(builder: (context) => SignUpPage());
      return SignUpPage();
    } else {
      MaterialPageRoute(builder: (context) => SosPage());
      return SosPage();
    }
  }
}