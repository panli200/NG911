import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psap_dashboard/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
        apiKey: "AIzaSyB5Z8MWrQ5ZZJCUJBZhL6r_Axf_OiZGdEc",
        authDomain: "sos-app-3af53.firebaseapp.com",
        databaseURL: "https://sos-app-3af53-default-rtdb.firebaseio.com",
        projectId: "sos-app-3af53",
        storageBucket: "sos-app-3af53.appspot.com",
        messagingSenderId: "728757332541",
        appId: "1:728757332541:web:22b0f46cb91234e88e5854",
        measurementId: "G-GH5H3WTRBN"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'PSAP Control Panel';
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginPage(),
      );
}

