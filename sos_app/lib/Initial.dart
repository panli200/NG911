import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sos_app/SignUp.dart';
import 'package:sos_app/sos.dart';
import 'package:sos_app/routes/router.gr.dart';
import 'package:auto_route/src/router/auto_router_x.dart';

class InitializerWidgetPage extends StatelessWidget {
  FirebaseAuth? _auth;

  User? _user;
  void getUser(){
    _auth = FirebaseAuth.instance;
    _user = _auth!.currentUser;
  }
  InitializerWidgetPage({Key? key}) : super(key: key);




  bool isLoading = true;
  @override
  void initState() async{
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    if (_user == null) {
      MaterialPageRoute(builder: (context) => SignUpPage());
      return SignUpPage();
    } else {
      context.router
          .pushAndPopUntil(HomeRouter(), predicate: (route) => false);
      return SignUpPage();
    }
  }
}