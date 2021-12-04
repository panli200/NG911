
import 'package:flutter/material.dart';

class CallControlPanel extends StatefulWidget {
  const CallControlPanel({Key? key}) : super(key: key);

  @override
  State<CallControlPanel> createState() => _CallControlPanelState();
}

class _CallControlPanelState extends State<CallControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incoming Call Control Panel"),
        backgroundColor: Colors.redAccent,
      ),

    );
  }
}