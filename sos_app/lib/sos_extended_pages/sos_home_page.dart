import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sos_app/routes/router.gr.dart';
import 'package:sos_app/data/application_data.dart';
import 'package:sos_app/services/call_type.dart';
import 'package:sos_app/widgets.dart';
import 'package:sos_app/profile_extended_pages/upload_file.dart';
import 'package:sos_app/services/location.dart';
import 'package:sos_app/services/send_call_history.dart';
import 'package:sos_app/services/send_realtime_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sos_app/sos_extended_pages/call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sos_app/profile_extended_pages/send_profile_data.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:sos_app/services/encryption.dart';
import 'package:cryptography/cryptography.dart';
import 'package:sos_app/services/connectionStatus.dart';

class SosHomePage extends StatefulWidget {
  SosHomePage({Key? key}) : super(key: key);

  @override
  SosHomePageState createState() => SosHomePageState();
}

class SosHomePageState extends State<SosHomePage> {
  //For RSA encryption
  Future<crypto.AsymmetricKeyPair>? futureKeyPair;
  crypto.AsymmetricKeyPair? keyPair;   //to store the KeyPair once we get data from our future
  late var publicKey;
  late var privKey;
  late String publicKeyString;
  late final aesAlgorithm;
  late final aesSecretKey;
  final howToUsePopUp = HowToUseData.howToUsePopUp;
  void Encrypt()async{
    futureKeyPair    =  getKeyPair();
    keyPair          =  await futureKeyPair;
    publicKey =  keyPair!.publicKey;
    privKey   =  keyPair!.privateKey;
    var helper = RsaKeyHelper();
    publicKeyString = helper.encodePublicKeyToPemPKCS1(publicKey);
    aesAlgorithm = AesCtr.with256bits(macAlgorithm: Hmac.sha256());
    aesSecretKey = aesAlgorithm.newSecretKey();
    setState(() {

    });
  }

  void _callNumber(String? date) async {
    // Encryption generate public and private keys

    Location location = Location();
    await location.getCurrentLocation();
    String user = FirebaseAuth.instance.currentUser!.uid.toString();
    String mobile = FirebaseAuth.instance.currentUser!.phoneNumber.toString();

    CollectionReference emergencies= FirebaseFirestore.instance.collection('SOSEmergencies');
    emergencies.doc(mobile).set({
      'Online': false,
      'Phone': mobile,
      'User': user,
      'StartLocation': GeoPoint(location.latitude, location.longitude),
      'StartTime': date,
      'Waiting': true,
    },SetOptions(merge: true));
}

  @override
  void initState(){
    Encrypt();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: isConnected(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
             bool isConnected = snapshot.data;
             if(isConnected){
               return Row(
                 children: [
                   Text("Internet connected")
                 ],

               );
             }else{
               return Row(
                 children: [
                   Text("Internet not connected")
                 ],

               );

             }
            },

          ),
          Container(
            height: 40,
            width: 40,
            child: HowToUseButton(
                tileColor: howToUsePopUp.color,
                pageTitle: howToUsePopUp.title,
                onTileTap: () => context.router.push(
                      HowToUseRoute(
                        howToUseID: howToUsePopUp.id,
                      ),
                    ) // onTileTap
                ),
          ), // How To Use App Placeholder

          SizedBox(height: 20), // Spacing visuals

          Center(
            child: Text(
              'Make an emergency call for:',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),

          SizedBox(height: 20), // Spacing visuals

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Container(
                      child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () async{
                  WidgetsFlutterBinding.ensureInitialized();
                  var now = new DateTime.now();
                  String? date = now.toString();
                  _callNumber(date);
                  updateSensors(date, publicKeyString, aesSecretKey);
                  sendUserDate(); //TEST calling send the user profile function to send the data to firebase
                  uploadFile(); //TEST upload files to the firebase storage
                  updateHistory(); //Test adding call history database
                  sendLocationHistory(); // send last 10 minutes "or less minutes since started" of location history
                  sendUpdatedLocation(); // send location on FireBbase each 5 seconds to be accessed on callcontrol page map
                  personal(); //Test adding call type
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CallPage(privateKey: privKey,publicKey: publicKey, aesKey: aesSecretKey)),
                  );
                },
                child: Text("Yourself"),
              ))),

              SizedBox(height: 20), // Spacing visuals

              Center(
                  child: Container(
                      child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  var now = new DateTime.now();
                  String? date = now.toString();
                  _callNumber(date);
                  updateSensors(date, publicKeyString, aesSecretKey);
                  sendUserDate(); //TEST calling send the user profile function to send the data to firebase
                  uploadFile(); //TEST upload files to the firebase storage
                  updateHistory(); //Test adding call history database
                  sendLocationHistory();// send last 10 minutes "or less minutes since started" of location history
                  sendUpdatedLocation(); // send location on FireBbase each 5 seconds to be accessed on callcontrol page map
                  contact(); //Test adding call type
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CallPage(privateKey: privKey,publicKey: publicKey, aesKey: aesSecretKey)),
                  );
                },
                child: Text("Emergency Contact"),
              ))),

              SizedBox(height: 20), // Spacing visuals

              Center(
                  child: Container(
                      child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  var now = new DateTime.now();
                  String? date = now.toString();
                  _callNumber(date);
                  updateSensors(date, publicKeyString, aesSecretKey);
                  updateHistory(); //Test adding call history database
                  sendLocationHistory();// send last 10 minutes "or less minutes since started" of location history
                  sendUpdatedLocation(); // send location on FireBbase each 5 seconds to be accessed on callcontrol page map
                  standby();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CallPage(privateKey: privKey,publicKey: publicKey, aesKey: aesSecretKey)),
                  );
                },
                child: Text("Third Party (Bystander)"),
              ))),

              // const Divider(
              //   height: 10,
              //   thickness: 5,
              // ),
            ],
          ) // SOS Scenario Button Placeholders
        ],
      ),
    ));
  }
}
