import 'package:pointycastle/api.dart' as crypto;
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>> getKeyPair()
{
  var helper = RsaKeyHelper();
  return helper.computeRSAKeyPair(helper.getSecureRandom());
}

Future<crypto.PublicKey> getPublicKeyFromDispatcher (String phone)async{
  CollectionReference EmergencyData =  FirebaseFirestore.instance.collection('SOSEmergencies');;
  var details =  EmergencyData.doc(phone).get();

  late var publicKey;
  await details.then((snapshot) {
    publicKey = snapshot['dispatcher_public_key'] as crypto.PublicKey;
    return publicKey;
  });
  return publicKey;
}