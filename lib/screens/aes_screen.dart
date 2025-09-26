import 'package:flutter/material.dart';
import '../services/crypto_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_display.dart';

class AesScreen extends StatefulWidget {
  const AesScreen({Key? key}) : super(key: key);

  @override
  _AesScreenState createState() => _AesScreenState();
}

class _AesScreenState extends State<AesScreen> {
  final _textController = TextEditingController();
  final _keyController = TextEditingController();
  final _ivController = TextEditingController();
  final _cryptoService = CryptoService();
  String _result = '';

  void _encrypt() {
    setState(() {
      try {
        final Map<String, String> encryptedData =
            _cryptoService.aesEncrypt(_textController.text, _keyController.text);
        _result = encryptedData['ciphertext']!;
        _ivController.text = encryptedData['iv']!; // Tampilkan IV yang digenerate
      } catch (e) {
        _result = 'Error: ${e.toString()}';
      }
    });
  }

  void _decrypt() {
    setState(() {
      try {
        _result = _cryptoService.aesDecrypt(
            _textController.text, _keyController.text, _ivController.text);
      } catch (e) {
        _result = 'Error: ${e.toString()}';
      }
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
            'AES Encryption',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _textController,
            labelText: 'Masukkan Teks / Ciphertext (Base64)',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _keyController,
            labelText: 'Kunci (16, 24, atau 32 karakter)',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _ivController,
            labelText: 'IV (Base64) - akan terisi otomatis saat enkripsi',
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                  child: CustomButton(text: 'Enkripsi', onPressed: _encrypt)),
              const SizedBox(width: 16),
              Expanded(
                  child: CustomButton(
                      text: 'Dekripsi',
                      onPressed: _decrypt,
                      color: Colors.blueGrey)),
            ],
          ),
          const SizedBox(height: 24),
          if (_result.isNotEmpty) ResultDisplay(result: _result),
        ],
      ),
    );
  }
}