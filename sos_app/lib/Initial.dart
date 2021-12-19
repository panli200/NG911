import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sos_app/sos_extended_pages/sos_home_page.dart';
import 'package:sos_app/SignUp.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/routes/router.gr.dart';
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
//class InitializerWidgetPage extends StatelessWidget{
//  FirebaseAuth? _auth;
////
//  late User _user;
////
//  bool isLoading = true;
//  @override
//  void initState() {
//    _auth = FirebaseAuth.instance;
//    _user!= _auth?.currentUser;
//    isLoading = false;
//  }
//  @override
//  Widget build(BuildContext context) {
//
//  }
//  }
//
//}
//class InitializerWidgetPage extends StatelessWidget {
//  @override
//  Future<Widget> build(BuildContext context) async {
//    FirebaseAuth? _auth;
////
//    User? _user;
////
//    bool isLoading = true;
////
////
//    @override
//    void initState() {
//      _auth = FirebaseAuth.instance;
//      _user!= _auth?.currentUser;
//      isLoading = false;
//    }
//
//    @override
//    Widget build(BuildContext context) {
//
//      print("I am inside the initializer page");
//      if (isLoading!) {
//        return Scaffold(
//          body: Center(
//            child: CircularProgressIndicator(),
//          ),
//        );
//      } else {
//        MaterialPageRoute(builder: (context) => SosPage());
//
//        if (_user != null) {
//
//
//          print("Good to SOS-Page");
//          MaterialPageRoute(builder: (context) => SosPage());
//          return Scaffold(
//
//          );
//
//        } else {
//
//          print("The user isn't registered");
//          MaterialPageRoute(builder: (context) => SignUpPage());
//
//          return Scaffold(
//
//          );
//        }
//      }
//
//    }
//
//  }
//}
