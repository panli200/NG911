import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:path/path.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:sos_app/profile_extended_pages/sos_user.dart';
import 'package:sos_app/profile_extended_pages/dialog_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_app/profile_extended_pages/sliding_switch_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? file, fileT;
  PhoneContact? _phoneContact;
  String emergencyName = '';
  TextEditingController ctlHealthCard = TextEditingController();
  TextEditingController ctlHealthCard2 = TextEditingController();
  bool sw1 = false;
  bool sw2 = false;
  bool sw3 = false;
  SOSUser _user = SOSUser();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  String textBackground = "Start Service";
  getGeneralValue() async {
    prefs = await _prefs;

    setState(() {
      _user.generalPermission = (prefs.containsKey("GeneralPermission")
          ? prefs.getBool("GeneralPermission")
          : false)!;

      _user.contactNum =
          (prefs.containsKey("Contact") ? prefs.getString("Contact") : '')!;
    });
  }

  getMedicalValue() async {
    prefs = await _prefs;

    setState(() {
      _user.personalMedicalPermission =
          (prefs.containsKey("PersonalMedicalPermission")
              ? prefs.getBool("PersonalMedicalPermission")
              : false)!;
      _user.personalHealthNum =
          (prefs.containsKey("HealthNum") ? prefs.getString("HealthNum") : '')!;
      _user.personalMedicalFile = (prefs.containsKey("PersonalFile")
          ? prefs.getString("PersonalFile")
          : '')!;
      _user.contactMedicalPermission =
          (prefs.containsKey("contactMedicalPermission")
              ? prefs.getBool("contactMedicalPermission")
              : false)!;
      _user.contactHealthNum = (prefs.containsKey("ContactHealthNum")
          ? prefs.getString("ContactHealthNum")
          : '')!;
      _user.contactMedicalFile = (prefs.containsKey("ContactFile")
          ? prefs.getString("ContactFile")
          : '')!;
    });
  }

  saveGeneralValue() async {
    prefs.setBool("GeneralPermission", _user.generalPermission);
    prefs.setString("Contact", _user.contactNum);
  }

  saveMedicalValue() async {
    prefs.setBool("PersonalMedicalPermission", _user.personalMedicalPermission);
    prefs.setString("HealthNum", _user.personalHealthNum);
    prefs.setString("PersonalFile", _user.personalMedicalFile);
    prefs.setString("PersonalFilePath", _user.personalMedicalFilePath);
    prefs.setBool("contactMedicalPermission", _user.contactMedicalPermission);
    prefs.setString("ContactHealthNum", _user.contactHealthNum);
    prefs.setString("ContactFile", _user.contactMedicalFile);
    prefs.setString("ContactFilePath", _user.contactMedicalFilePath);
  }

  void initState() {
    super.initState();
    getGeneralValue();
    getMedicalValue();
  }

  void dispose() {
    ctlHealthCard.dispose();
    ctlHealthCard2.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text("Profile"),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Scrollbar(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
/************************************************************* START OF GENERAL INFORMATION *************************************************************/
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    FlutterRemix.information_fill,
                                    color: Colors.amber,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    showGeneralDialogBox(context);
                                  }),
                              Text(
                                'General Information',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),

                          const Divider(
                            height: 5,
                            thickness: 3,
                            color: Colors.black12,
                          ),

                          SizedBox(
                            height: 16.0,
                          ),

                          Row(
                            children: [
                              Text(
                                'Permission to Share: ',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SlidingSwitchWidget(
                                choice: false,
                                onClicked: (bool systemOverlaysAreVisible) async {
                                  sw1 = systemOverlaysAreVisible;
                                },
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 24.0,
                          ), // SPACING

                          Row(
                            children: [
                              Text(
                                'Full Legal Name: ',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Bugs Capstone ',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 16.0,
                          ), // SPACING

                          Row(
                            children: [
                              Text(
                                'Emergency Contact No: ',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  _user.contactNum,
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  FlutterRemix.user_add_fill,
                                  color: Colors.teal,
                                  size: 26,
                                ),
                                onPressed: () async {
                                  final PhoneContact contact =
                                      await FlutterContactPicker
                                          .pickPhoneContact();
                                  setState(() {
                                    _phoneContact = contact;
                                    _user.contactNum = (_phoneContact != null
                                        ? (_phoneContact!.fullName! +
                                            _phoneContact!.phoneNumber!.number!)
                                        : '');
                                    emergencyName = _phoneContact!.fullName!;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  FlutterRemix.user_unfollow_fill,
                                  color: Colors.red,
                                  size: 26,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _phoneContact = null;
                                    _user.contactNum = '';
                                    emergencyName = '';
                                  });
                                },
                              ),
                            ],
                          ),

                          const Divider(
                            height: 5,
                            thickness: 3,
                            color: Colors.black12,
                          ),

                          SizedBox(
                            height: 8.0,
                          ), // SPACING

                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            //EDIT GENERAL INFORMATION DIALOG
                            onPressed: () {
                              setState(() {
                                _user.generalPermission = sw1;
                              });
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Edit General Information'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        const Text('Permission: '),
                                        Text(
                                          checkPermission(
                                              _user.generalPermission),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.brown),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        const Text('Emergency Contact: '),
                                        Text(
                                          _user.contactNum,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.brown),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        saveGeneralValue();
                                        Navigator.pop(context, 'OK');
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('SAVE GENERAL INFORMATION'),
                          ),

                          SizedBox(
                            height: 16.0,
                          ),
                        ],
                      ),
                    ),
/************************************************************* END OF GENERAL INFORMATION *************************************************************/

                    SizedBox(
                      height: 8.0,
                    ),

/************************************************************* START OF MEDICAL INFORMATION *************************************************************/
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    FlutterRemix.information_fill,
                                    color: Colors.amber,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    showMedicalDialogBox(context);
                                  }),
                              Text(
                                'Medical Information',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),

                          const Divider(
                            height: 5,
                            thickness: 3,
                            color: Colors.black12,
                          ),

                          SizedBox(
                            height: 8.0,
                          ), // SPACING

                          Text(
                            'Personal ',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 17,
                            ),
                          ),

                          SizedBox(
                            height: 16.0,
                          ), // SPACING

                          Row(
                            children: [
                              Text(
                                'Permission to Share: ',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SlidingSwitchWidget(
                                choice: false,
                                onClicked: (bool systemOverlaysAreVisible) async {
                                  sw2 = systemOverlaysAreVisible;
                                },
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 16.0,
                          ), // SPACING

                          Column(
                            children: [
                              Text(
                                'Health Card Number',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.length >= 1 && value.length <= 11) {
                                    return 'Please enter 7-12 digits';
                                  }
                                  return null;
                                },
                                maxLength: 12,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(12),
                                ],
                                decoration: const InputDecoration(
                                  labelText: '7-12 Digits',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                controller: ctlHealthCard,
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 8.0,
                          ), // SPACING

                          Row(
                            children: [
                              Text(
                                'Medical History: ',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  _user.personalMedicalFile,
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  FlutterRemix.attachment_2,
                                  color: Colors.teal,
                                  size: 26,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    selectFile();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  FlutterRemix.delete_bin_2_fill,
                                  color: Colors.red,
                                  size: 26,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    file = null;
                                    _user.personalMedicalFile =
                                        ''; // File is null
                                  });
                                },
                              ),
                            ],
                          ),

                          const Divider(
                            height: 5,
                            thickness: 3,
                            color: Colors.black12,
                          ),

                          SizedBox(
                            height: 8.0,
                          ), // SPACING

                          Text(
                            'Emergency Contact Information',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 17,
                            ),
                          ),

                          SizedBox(
                            height: 16.0,
                          ), // SPACING

                          Row(
                            children: [
                              Text(
                                'Permission to Share: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SlidingSwitchWidget(
                                choice: false,
                                onClicked: (bool systemOverlaysAreVisible) async {
                                  sw3 = systemOverlaysAreVisible;
                                },
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 16.0,
                          ), // SPACING

                          Row(
                            children: [
                              Text(
                                'Full Legal Name: ',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // Text('Dr. Morgan', style: const TextStyle(fontWeight: FontWeight.bold),),
                              Text(
                                emergencyName,
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 16.0,
                          ), // SPACING

                          Column(
                            children: [
                              Text(
                                'Health Card Number',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.length >= 1 && value.length <= 11) {
                                    return 'Please enter 7-12 digits';
                                  }
                                  return null;
                                },
                                maxLength: 12,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(12),
                                ],
                                decoration: const InputDecoration(
                                  labelText: '7-12 Digits',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                controller: ctlHealthCard2,
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 8.0,
                          ), // SPACING

                          Row(
                            children: [
                              Text(
                                'Medical History: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _user.contactMedicalFile,
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  FlutterRemix.attachment_2,
                                  color: Colors.teal,
                                  size: 26,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    selectFileT();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  FlutterRemix.delete_bin_2_fill,
                                  color: Colors.red,
                                  size: 26,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    fileT = null;
                                    _user.contactMedicalFile = ''; // File is null
                                  });
                                },
                              ),
                            ],
                          ),

                          const Divider(
                            height: 5,
                            thickness: 3,
                            color: Colors.black12,
                          ),

                          SizedBox(
                            height: 16.0,
                          ), // SPACING

                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _user.personalHealthNum = ctlHealthCard.text;
                                  _user.contactHealthNum = ctlHealthCard2.text;
                                  _user.personalMedicalPermission = sw2;
                                  _user.contactMedicalPermission = sw3;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Edit Medical Information'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          const Text('Personal Permission: '),
                                          Text(
                                            checkPermission(
                                                _user.personalMedicalPermission),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          const Text('Personal Health Card No:'),
                                          Text(
                                            _user.personalHealthNum,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          const Text('Personal Medical History:'),
                                          Text(
                                            _user.personalMedicalFile,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          const Text(
                                              'Emergency Contact Permission: '),
                                          Text(
                                            checkPermission(
                                                _user.contactMedicalPermission),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          const Text(
                                              'Emergency Contact Health Card No:'),
                                          Text(
                                            _user.contactHealthNum,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          const Text(
                                              'Emergency Contact Medical History:'),
                                          Text(
                                            _user.contactMedicalFile,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          saveMedicalValue();
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: const Text('SAVE MEDICAL INFORMATION'),
                          )
                        ],
                      ),
                    ),
/************************************************************* END OF MEDICAL INFORMATION *************************************************************/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //function for select file
  Future selectFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));

    _user.personalMedicalFile = file != null ? basename(file!.path) : '';
    _user.personalMedicalFilePath = path;
  }

  Future selectFileT() async {
    final result2 = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result2 == null) return;
    final path2 = result2.files.single.path!;

    setState(() => fileT = File(path2));

    _user.contactMedicalFile = fileT != null ? basename(fileT!.path) : '';
    _user.contactMedicalFilePath = path2;
  }

  //function for check the permission
  String checkPermission(permission) {
    if (permission == true)
      return "Given";
    else
      return "Not Given";
  }
}
