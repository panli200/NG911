import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/annotations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String mobileNum;
  late String message;
  late String emergencyNum;
  late String healthNum;
  late String healthNumT;
  UploadTask? task, taskT;//
  File? file, fileT;

  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    final fileNameT = fileT != null ? basename(fileT!.path) : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.comment_rounded,
                      size: 26,
                    ),
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('General Information Use',
                            textAlign: TextAlign.center),
                        content: const Text(
                            'General information will be use for 911 emergency. '
                            'Your information only be used with your permission.'
                            'You have the responsibility to keep your information safe. '
                            'Your can select "No" for not giving your information to 911'),
                        actions: <Widget>[
                          new IconButton(
                            icon: new Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(null),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'General Information',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Permission to Share: ',
                    style: const TextStyle(),
                  ),
                  SlidingSwitch(
                    value: false,
                    width: 100,
                    onChanged: (bool value) {
                      print(value);
                    },
                    height: 30,
                    animationDuration: const Duration(milliseconds: 400),
                    onTap: () {},
                    onDoubleTap: () {},
                    onSwipe: () {},
                    textOff: "No",
                    textOn: "Yes",
                    colorOn: const Color(0xffdc6c73),
                    colorOff: const Color(0xff6682c0),
                    background: const Color(0xffe4e5eb),
                    buttonColor: const Color(0xfff7f5f7),
                    inactiveColor: const Color(0xff636f7b),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              RichText(
                text: TextSpan(
                  text: 'Full Legal Name: ',
                  style: DefaultTextStyle.of(context).style,
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'Bugs Capstone',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'Mobile: ',
                    style: const TextStyle(),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        mobileNum=value;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Text-to-Speech Message: ',
                    style: const TextStyle(),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        message = value;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Emergency Contract: ',
                    style: const TextStyle(),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        emergencyNum = value;
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                //EDIT GENERAL INFORMATION DIALOG
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Edit General Information'),
                    content:
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text('Mobile'),
                            Text(mobileNum),
                            const Text('Text-to-Speech Message'),
                            Text(message),
                            const Text('Emergency'),
                            Text(emergencyNum),
                          ],
                        ),
                      ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
                child: const Text('EDIT GENERAL INFORMATION'),
              ),
              SizedBox(
                height: 8.0,
              ),
              const Divider(
                height: 10,
                thickness: 5,
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.comment_rounded,
                      size: 26,
                    ),
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Medical Information Use',
                            textAlign: TextAlign.center),
                        content: const Text(
                            'Medical information will be use for 911 emergency. '
                            'Your information only be used with your permission.'
                            'You have the responsibility to keep your information safe. '
                            'Your can select "No" for not giving your information to 911'),
                        actions: <Widget>[
                          new IconButton(
                            icon: new Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(null),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Medical Information',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              Text(
                'Personal ',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Text(
                    'Permission to Share: ',
                    style: const TextStyle(),
                  ),
                  SlidingSwitch(
                    value: false,
                    width: 100,
                    onChanged: (bool value) {
                      print(value);
                    },
                    height: 30,
                    animationDuration: const Duration(milliseconds: 400),
                    onTap: () {},
                    onDoubleTap: () {},
                    onSwipe: () {},
                    textOff: "No",
                    textOn: "Yes",
                    colorOn: const Color(0xffdc6c73),
                    colorOff: const Color(0xff6682c0),
                    background: const Color(0xffe4e5eb),
                    buttonColor: const Color(0xfff7f5f7),
                    inactiveColor: const Color(0xff636f7b),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Health Card No:',
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        healthNum = value;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Text(
                    'Medical History: ',
                    style: const TextStyle(),
                  ),
                  Text(
                    fileName,
                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              ElevatedButton(
                  onPressed: () => selectFile(),
                  child: const Text('Select File'),
                ),
              SizedBox(
                height: 18.0,
              ),
              Text(
                'Emergency Contact',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Text(
                    'Permission to Share: ',
                    style: const TextStyle(),
                  ),
                  SlidingSwitch(
                    value: false,
                    width: 100,
                    onChanged: (bool value) {
                      print(value);
                    },
                    height: 30,
                    animationDuration: const Duration(milliseconds: 400),
                    onTap: () {},
                    onDoubleTap: () {},
                    onSwipe: () {},
                    textOff: "No",
                    textOn: "Yes",
                    colorOn: const Color(0xffdc6c73),
                    colorOff: const Color(0xff6682c0),
                    background: const Color(0xffe4e5eb),
                    buttonColor: const Color(0xfff7f5f7),
                    inactiveColor: const Color(0xff636f7b),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Health Card No:',
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        healthNumT = value;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Text(
                    'Medical History: ',
                    style: const TextStyle(),
                  ),
                  Text(
                    fileNameT,
                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              ElevatedButton(
                onPressed: () => selectFileT(),
                child: const Text('Select File'),
              ),
              SizedBox(
                height: 8.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Edit MedicalInformation'),
                    content:
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text('Health Card No:'),
                          Text(healthNum),
                          const Text('Medical History:'),
                          Text(fileName),
                          const Text('Health Card No:'),
                          Text(healthNumT),
                          const Text('Medical History:'),
                          Text(fileNameT),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
                child: const Text('EDIT MEDICAL INFORMATION'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }
  Future selectFileT() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => fileT = File(path));
  }

}