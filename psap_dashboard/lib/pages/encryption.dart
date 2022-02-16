import 'package:pointycastle/api.dart' as crypto;
import 'package:rsa_encrypt/rsa_encrypt.dart';

Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>> getKeyPair()
{
  var helper = RsaKeyHelper();
  return helper.computeRSAKeyPair(helper.getSecureRandom());
}

String getPublicKey(){
  String nonChangeablePublicKeyOnPsapOnly = "-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCz7Vw/k08XJv09oEE+IBpVEEcx1UMIl0/hIgrbiH1SsfjHDDo7aOrF5SjWT0KVtPr31YHAoWOXLUhiNOH4ndfidlpIdWvc58uPFgnFB5HAK4uRvuprXyI5oXpfqePZCPZSKd7icKZTupTGWZ2bcosGzrK6DRlSJajevBDw+07e/QIDAQAB-----END PUBLIC KEY-----";
  return nonChangeablePublicKeyOnPsapOnly;
}


crypto.PrivateKey getPrivateKey(){
  String nonChangeablePrivateKeyOnPsapOnly = "-----BEGIN RSA PRIVATE KEY-----MIICWwIBAAKBgQCz7Vw/k08XJv09oEE+IBpVEEcx1UMIl0/hIgrbiH1SsfjHDDo7aOrF5SjWT0KVtPr31YHAoWOXLUhiNOH4ndfidlpIdWvc58uPFgnFB5HAK4uRvuprXyI5oXpfqePZCPZSKd7icKZTupTGWZ2bcosGzrK6DRlSJajevBDw+07e/QIDAQABAoGAD3OGxH7l/9r9TFmCwM8I890eAA2MYCR+W5sMy6WA/aUC9DT8mzV7U9tGEoFj +m88TiQrrFsvrj/ZQ3W/IhaL/2VEdhn/PSW8UiPSORyb/VQuezXC1zhs3juOL6Kj7xbpl80NNDm3+4wuo4HiqQCH5ijpSIR4MlkDbZEP+8VkhgECQQD9Pr9+vmuxqmdijYI2RMGWXdAGgP0h3h+/VEcXWDPR8hp8zMj4oxByfeePXE4nX2AVNHEtccyUXqmcb2FQrgUdAkEAteJupr3bPhGDZWnXhY9/wfJJn8Fy0kbkMIyRtjoN4xuQtcIqnvClhpRtmE2LArbmjR+bZeYqW1pIkdLUvnJ7YQJACASjlYS77i0iBtnKJKO6qWMhAgO1gAwDX1Bwy8lsIpqSwh7NwimPjMB1w3E9vDtl1GYLq0+uFYiFwEE6iI5p9QJADs5jAZHdAh1828mU8NtwpAIsOiQOS83Xj5gx2Gq7bKx2yEUJIS0n3F/C2C4fzdXDyOM0zEPDWPJti+lkxigdoQJADqFDFYAyxxDcLQC2i6dHSohn51eB/zUKwh4IEL51Agc9mR1gxuXW7ruEBFSi/RW8xZfeDA5UVIiThQlq4Ov+gw==-----END RSA PRIVATE KEY-----";
  var helper = RsaKeyHelper();
  return helper.parsePrivateKeyFromPem(nonChangeablePrivateKeyOnPsapOnly);
}