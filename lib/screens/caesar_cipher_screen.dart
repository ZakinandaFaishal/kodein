import 'package:flutter/material.dart';
import '../services/crypto_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/result_display.dart';

class CaesarCipherScreen extends StatefulWidget {
  const CaesarCipherScreen({Key? key}) : super(key: key);

  @override
  _CaesarCipherScreenState createState() => _CaesarCipherScreenState();
}

class _CaesarCipherScreenState extends State<CaesarCipherScreen> {
  final _textController = TextEditingController();
  final _keyController = TextEditingController();
  final _cryptoService = CryptoService();
  String _result = '';

  void _encrypt() {
    setState(() {
      try {
        final key = int.parse(_keyController.text);
        _result = _cryptoService.caesarEncrypt(_textController.text, key);
      } catch (e) {
        _result = 'Error: Kunci harus berupa angka.';
      }
    });
  }

  void _decrypt() {
    setState(() {
      try {
        final key = int.parse(_keyController.text);
        _result = _cryptoService.caesarDecrypt(_textController.text, key);
      } catch (e) {
        _result = 'Error: Kunci harus berupa angka.';
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
            'Caesar Cipher',
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
            labelText: 'Masukkan Kunci (Angka)',
          ),
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