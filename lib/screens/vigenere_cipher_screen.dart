import 'package:flutter/material.dart';
import '../services/crypto_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_display.dart';

class VigenereCipherScreen extends StatefulWidget {
  const VigenereCipherScreen({Key? key}) : super(key: key);

  @override
  _VigenereCipherScreenState createState() => _VigenereCipherScreenState();
}

class _VigenereCipherScreenState extends State<VigenereCipherScreen> {
  final _textController = TextEditingController();
  final _keyController = TextEditingController();
  final _cryptoService = CryptoService();
  String _result = '';

  void _encrypt() {
    if (_keyController.text.isEmpty) {
      setState(() {
        _result = 'Error: Kunci tidak boleh kosong.';
      });
      return;
    }
    setState(() {
      _result = _cryptoService.vigenereEncrypt(
          _textController.text, _keyController.text);
    });
  }

  void _decrypt() {
    if (_keyController.text.isEmpty) {
      setState(() {
        _result = 'Error: Kunci tidak boleh kosong.';
      });
      return;
    }
    setState(() {
      _result = _cryptoService.vigenereDecrypt(
          _textController.text, _keyController.text);
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
            'Vigenère Cipher',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _textController,
            labelText: 'Masukkan Teks',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _keyController,
            labelText: 'Masukkan Kunci (Teks)',
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