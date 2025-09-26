import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../services/crypto_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_display.dart';

class SuperEncryptScreen extends StatefulWidget {
  const SuperEncryptScreen({Key? key}) : super(key: key);

  @override
  _SuperEncryptScreenState createState() => _SuperEncryptScreenState();
}

class _SuperEncryptScreenState extends State<SuperEncryptScreen> {
  final _textController = TextEditingController();
  final _caesarKeyController = TextEditingController();
  final _vigenereKeyController = TextEditingController();
  final _aesKeyController = TextEditingController();
  final _rsaPublicKeyController = TextEditingController();
  final _rsaPrivateKeyController = TextEditingController();
  final _ivController = TextEditingController();

  final _cryptoService = CryptoService();
  String _result = '';

  void _encrypt() {
    try {
      final caesarKey = int.parse(_caesarKeyController.text);
      final rsaParser = encrypt.RSAKeyParser();
      final rsaPublicKey = rsaParser.parse(_rsaPublicKeyController.text) as RSAPublicKey;
      
      final Map<String, String> encryptedData = _cryptoService.superEncrypt(
        _textController.text,
        caesarKey,
        _vigenereKeyController.text,
        _aesKeyController.text,
        rsaPublicKey,
      );

      setState(() {
        _result = encryptedData['ciphertext']!;
        _ivController.text = encryptedData['iv']!;
      });
    } catch (e) {
      setState(() {
        _result = 'Error enkripsi: ${e.toString()}';
      });
    }
  }

  void _decrypt() {
    try {
      final caesarKey = int.parse(_caesarKeyController.text);
      final rsaParser = encrypt.RSAKeyParser();
      final rsaPrivateKey = rsaParser.parse(_rsaPrivateKeyController.text) as RSAPrivateKey;

      final decryptedText = _cryptoService.superDecrypt(
        _textController.text,
        caesarKey,
        _vigenereKeyController.text,
        _aesKeyController.text,
        _ivController.text,
        rsaPrivateKey,
      );
      setState(() {
        _result = decryptedText;
      });
    } catch (e) {
      setState(() {
        _result = 'Error dekripsi: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Super Enkripsi',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _textController,
            labelText: 'Teks Awal / Teks Terenkripsi Super',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Text("Kunci-kunci yang Dibutuhkan", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          CustomTextField(controller: _caesarKeyController, labelText: '1. Kunci Caesar (Angka)'),
          const SizedBox(height: 8),
          CustomTextField(controller: _vigenereKeyController, labelText: '2. Kunci Vigenère (Teks)'),
          const SizedBox(height: 8),
          CustomTextField(controller: _aesKeyController, labelText: '3. Kunci AES (16/24/32 Karakter)'),
          const SizedBox(height: 8),
          CustomTextField(controller: _ivController, labelText: 'AES IV (Terisi saat enkripsi)'),
          const SizedBox(height: 8),
          CustomTextField(controller: _rsaPublicKeyController, labelText: '4. RSA Public Key (Untuk Enkripsi)', maxLines: 4),
          const SizedBox(height: 8),
          CustomTextField(controller: _rsaPrivateKeyController, labelText: '4. RSA Private Key (Untuk Dekripsi)', maxLines: 4),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: CustomButton(text: 'Enkripsi', onPressed: _encrypt)),
              const SizedBox(width: 16),
              Expanded(child: CustomButton(text: 'Dekripsi', onPressed: _decrypt, color: Colors.blueGrey)),
            ],
          ),
          const SizedBox(height: 24),
          if (_result.isNotEmpty) ResultDisplay(result: _result),
        ],
      ),
    );
  }
}