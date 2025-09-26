import 'package:flutter/material.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../services/crypto_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_display.dart';

class RsaScreen extends StatefulWidget {
  const RsaScreen({Key? key}) : super(key: key);

  @override
  _RsaScreenState createState() => _RsaScreenState();
}

class _RsaScreenState extends State<RsaScreen> {
  final _textController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _cryptoService = CryptoService();
  String _result = '';

  // VERSI BARU
  // encrypt.AsymmetricKeyPair<encrypt.RSAPublicKey, encrypt.RSAPrivateKey>?
  // _keyPair;

  // void _generateKeys() {
  //   final keyPair = _cryptoService.generateRsaKeyPair();
  //   final parser = encrypt.RSAKeyParser();

  //   // Menggunakan package encrypt untuk memformat ke PEM
  //   _publicKeyController.text = parser.encodePublicKeyToPem(keyPair.publicKey);
  //   _privateKeyController.text = parser.encodePrivateKeyToPem(
  //     keyPair.privateKey,
  //   );

  //   setState(() {
  //     _keyPair = keyPair;
  //     _result = 'Kunci baru berhasil dibuat!';
  //   });
  // }

  void _encrypt() {
    if (_publicKeyController.text.isEmpty) {
      setState(() {
        _result = 'Error: Generate atau masukkan Public Key terlebih dahulu.';
      });
      return;
    }
    final parser = encrypt.RSAKeyParser();
    final publicKey = parser.parse(_publicKeyController.text) as RSAPublicKey;
    setState(() {
      _result = _cryptoService.rsaEncrypt(_textController.text, publicKey);
    });
  }

  void _decrypt() {
    if (_privateKeyController.text.isEmpty) {
      setState(() {
        _result = 'Error: Generate atau masukkan Private Key terlebih dahulu.';
      });
      return;
    }
    final parser = encrypt.RSAKeyParser();
    final privateKey =
        parser.parse(_privateKeyController.text) as RSAPrivateKey;
    setState(() {
      _result = _cryptoService.rsaDecrypt(_textController.text, privateKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'RSA Encryption',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          // const SizedBox(height: 24),
          // CustomButton(
          //   text: 'Generate Kunci Baru',
          //   onPressed: _generateKeys,
          //   color: Colors.teal,
          // ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _publicKeyController,
            labelText: 'Public Key (Format PEM)',
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _privateKeyController,
            labelText: 'Private Key (Format PEM)',
            maxLines: 5,
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _textController,
            labelText: 'Masukkan Teks / Ciphertext (Base64)',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(text: 'Enkripsi', onPressed: _encrypt),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Dekripsi',
                  onPressed: _decrypt,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_result.isNotEmpty) ResultDisplay(result: _result),
        ],
      ),
    );
  }
}
