import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/annotations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sos_app/sos_extended_pages/sos_home_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Setup SOS Account',
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your Phone Number',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your Driver License',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your Health Card Number',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                child: Text(
                  'Uploading related files:',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Center(
                child: ElevatedButton(
                  onPressed: () => selectFile(),
                  child: const Text('Select File'),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                child: Text(
                  'Please be aware your information will be only used with your permission!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {
                    showAlert(context);
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showAlert(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content:
        Text("Would you like to share your information with us in emergency?"),
    actions: [
      TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SosHomePage()),
        ), // passing false
        child: Text('No'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, true), // passing true
        child: Text('Yes'),
      ),
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
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
