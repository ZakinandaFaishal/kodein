import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';

class CryptoService {
  // --- 1. Caesar Cipher ---
  String caesarEncrypt(String text, int shift) {
    return text.codeUnits.map((char) {
      if (char >= 65 && char <= 90) {
        return String.fromCharCode(((char - 65 + shift) % 26) + 65);
      } else if (char >= 97 && char <= 122) {
        return String.fromCharCode(((char - 97 + shift) % 26) + 97);
      }
      return String.fromCharCode(char);
    }).join('');
  }

  String caesarDecrypt(String text, int shift) {
    return caesarEncrypt(text, 26 - shift);
  }

  // --- 2. Vigenère Cipher ---
  String vigenereEncrypt(String text, String key) {
    String result = '';
    int keyIndex = 0;
    for (int i = 0; i < text.length; i++) {
      int charCode = text.codeUnitAt(i);
      if (charCode >= 65 && charCode <= 90) {
        int keyChar = key.toUpperCase().codeUnitAt(keyIndex % key.length);
        int shift = keyChar - 65;
        result += String.fromCharCode(((charCode - 65 + shift) % 26) + 65);
        keyIndex++;
      } else if (charCode >= 97 && charCode <= 122) {
        int keyChar = key.toLowerCase().codeUnitAt(keyIndex % key.length);
        int shift = keyChar - 97;
        result += String.fromCharCode(((charCode - 97 + shift) % 26) + 97);
        keyIndex++;
      } else {
        result += text[i];
      }
    }
    return result;
  }

  String vigenereDecrypt(String text, String key) {
    String invertedKey = '';
    for (int i = 0; i < key.length; i++) {
      int charCode = key.toUpperCase().codeUnitAt(i);
      invertedKey += String.fromCharCode(65 + (26 - (charCode - 65)) % 26);
    }
    return vigenereEncrypt(text, invertedKey);
  }

  // --- 3. AES ---
  Map<String, String> aesEncrypt(String text, String keyString) {
    if (keyString.length != 16 &&
        keyString.length != 24 &&
        keyString.length != 32) {
      throw 'Panjang kunci harus 16, 24, atau 32 karakter.';
    }
    final key = encrypt.Key.fromUtf8(keyString);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return {'ciphertext': encrypted.base64, 'iv': iv.base64};
  }

  String aesDecrypt(String base64Text, String keyString, String ivBase64) {
    if (keyString.length != 16 &&
        keyString.length != 24 &&
        keyString.length != 32) {
      throw 'Panjang kunci harus 16, 24, atau 32 karakter.';
    }
    final key = encrypt.Key.fromUtf8(keyString);
    final iv = encrypt.IV.fromBase64(ivBase64);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    try {
      return encrypter.decrypt64(base64Text, iv: iv);
    } catch (e) {
      throw 'Dekripsi gagal. Periksa kunci atau ciphertext.';
    }
  }

  // --- 4. RSA ---
// Lokasi: lib/services/crypto_service.dart

// VERSI BARU (benar dan lebih simpel)
// Perhatikan perubahan return type-nya
// encrypt.AsymmetricKeyPair<encrypt.RSAPublicKey, encrypt.RSAPrivateKey>
//     generateRsaKeyPair() {
//   return encrypt.RSA.generateKeyPair(_secureRandom());
// }

  String rsaEncrypt(String text, RSAPublicKey publicKey) {
    final encrypter = encrypt.Encrypter(
        encrypt.RSA(publicKey: publicKey, encoding: encrypt.RSAEncoding.PKCS1));
    return encrypter.encrypt(text).base64;
  }

  String rsaDecrypt(String base64Text, RSAPrivateKey privateKey) {
    final encrypter = encrypt.Encrypter(encrypt.RSA(
        privateKey: privateKey, encoding: encrypt.RSAEncoding.PKCS1));
    return encrypter.decrypt64(base64Text);
  }

  SecureRandom _secureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  // --- 5. Super Encryption ---
  Map<String, String> superEncrypt(String text, int caesarKey,
      String vigenereKey, String aesKey, RSAPublicKey rsaPublicKey) {
    String step1 = caesarEncrypt(text, caesarKey);
    String step2 = vigenereEncrypt(step1, vigenereKey);
    Map<String, String> aesResult = aesEncrypt(step2, aesKey);
    String step3 = aesResult['ciphertext']!;
    String step4 = rsaEncrypt(step3, rsaPublicKey);
    return {'ciphertext': step4, 'iv': aesResult['iv']!};
  }

  String superDecrypt(String text, int caesarKey, String vigenereKey,
      String aesKey, String ivBase64, RSAPrivateKey rsaPrivateKey) {
    String step1 = rsaDecrypt(text, rsaPrivateKey);
    String step2 = aesDecrypt(step1, aesKey, ivBase64);
    String step3 = vigenereDecrypt(step2, vigenereKey);
    String step4 = caesarDecrypt(step3, caesarKey);
    return step4;
  }
}