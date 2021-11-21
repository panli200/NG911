import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/annotations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_switch/sliding_switch.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String emergencyNum;
  late String healthNum;
  late String message;

  Widget build(BuildContext context) {
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
                children: [
                  IconButton(
                      icon: Icon(Icons.comment_rounded),
                      onPressed: () {
                        //Implement logout functionality
                      }),
                  Expanded(
                    child: Text(
                      'General Information',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
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
                    'Mobile:',
                    style: const TextStyle(),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {

                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Text-to-Speech Message:',
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
                    'Emergency Contract:',
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
                onPressed: () {},
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
                children: [
                  IconButton(
                      icon: Icon(Icons.comment_rounded),
                      onPressed: () {
                        //Implement logout functionality
                      }),
                  SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      'Medical Information',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
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
              Text(
                'Medical History:',
                style: const TextStyle(),
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
                'Emergency Contact #1 ',
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
              Text(
                'Medical History:',
                style: const TextStyle(),
              ),
              SizedBox(
                height: 8.0,
              ),
              ElevatedButton(
                onPressed: () => selectFile(),
                child: const Text('Select File'),
              ),
              SizedBox(
                height: 8.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {},
                child: const Text('EDIT MEDICAL INFORMATION'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void selectFile() async {
  //String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  //bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  //setState(() => _loadingPath = true);
  try {
    _directoryPath = null;
    _paths = (await FilePicker.platform.pickFiles(
      type: _pickingType,
      allowMultiple: _multiPick,
      allowedExtensions: (_extension?.isNotEmpty ?? false)
          ? _extension?.replaceAll(' ', '').split(',')
          : null,
    ))
        ?.files;
  } on PlatformException catch (e) {
    print("Unsupported operation" + e.toString());
  } catch (ex) {
    print(ex);
  }
}
