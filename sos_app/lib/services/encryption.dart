import 'package:pointycastle/api.dart' as crypto;
import 'package:rsa_encrypt/rsa_encrypt.dart';

Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
    getKeyPair() {
  var helper = RsaKeyHelper();
  return helper.computeRSAKeyPair(helper.getSecureRandom());
}
